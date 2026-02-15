#!/usr/bin/env Rscript

# BTW MCP Server v3.1
# Complete bidirectional visibility via evaluate package
# v3.0: 2025-09-30 | v3.1: 2026-02-15

library(mcptools)
library(btw)

# Load configuration - robust path resolution for MCP
config_path <- tryCatch({
  # Use commandArgs to get the script path reliably
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg) > 0) {
    script_path <- sub("^--file=", "", file_arg)
    script_dir <- dirname(script_path)
    file.path(script_dir, "config.R")
  } else {
    # Fallback: try sys.frame
    script_dir <- dirname(sys.frame(1)$ofile)
    file.path(script_dir, "config.R")
  }
}, error = function(e) {
  # Last fallback: try working directory
  file.path(getwd(), "src", "config.R")
})

if (file.exists(config_path)) {
  source(config_path, local = FALSE)  # Source into global environment
} else {
  stop("Cannot find config.R. Tried: ", config_path,
       "\nScript was launched from: ", getwd())
}

# Ensure all required objects are in global environment for tool access
assign("BTW_CONFIG", BTW_CONFIG, envir = .GlobalEnv)
assign("format_message", format_message, envir = .GlobalEnv)

# Socket connection cache to avoid repeated file system scans
.socket_cache <- new.env(parent = emptyenv())
.socket_cache$checked <- Sys.time() - BTW_CONFIG$SOCKET_CACHE_TIMEOUT - 1  # Force first check
.socket_cache$connected <- FALSE

# Assign socket cache to global environment
assign(".socket_cache", .socket_cache, envir = .GlobalEnv)

# Cached socket connection check (5-second cache)
is_session_connected <- function() {
  if (difftime(Sys.time(), .socket_cache$checked, units = "secs") > BTW_CONFIG$SOCKET_CACHE_TIMEOUT) {
    socket_files <- list.files(BTW_CONFIG$SOCKET_PATH, pattern = BTW_CONFIG$SOCKET_PATTERN, full.names = TRUE)
    .socket_cache$connected <- length(socket_files) > 0
    .socket_cache$checked <- Sys.time()
  }
  .socket_cache$connected
}

# Assign helper function to global environment (for socket check)
assign("is_session_connected", is_session_connected, envir = .GlobalEnv)

# Get all BTW tools
all_tools <- btw::btw_tools()

# Tools to EXCLUDE (Claude does these better)
exclude_tools <- BTW_CONFIG$EXCLUDE_TOOLS

# Filter out excluded tools
filtered_tools <- all_tools[!names(all_tools) %in% exclude_tools]

# Add execute_r with full v1 functionality
btw_tool_execute_r <- ellmer::tool(
  function(code, timeout = NULL) {
    # Self-contained configuration
    if (is.null(timeout)) timeout <- 30

    # Validate inputs
    if (!is.character(code) || length(code) == 0) {
      return("Error: Code must be a non-empty string")
    }

    if (!is.numeric(timeout) || timeout <= 0 || timeout > 600) {
      return(sprintf("Error: Timeout must be between 1 and 600 seconds (got %s)", timeout))
    }

    # Check for session connection (inline implementation)
    socket_files <- list.files("/tmp", pattern = "^mcptools-socket", full.names = TRUE)
    is_connected <- length(socket_files) > 0

    tryCatch({
      if (is_connected) {
        # Session mode: Try to use evaluate if available
        rstudio_available <- requireNamespace("rstudioapi", quietly = TRUE) &&
                           tryCatch(rstudioapi::isAvailable(), error = function(e) FALSE)

        # ALWAYS use evaluate for capture (so I can see everything)
        if (rstudio_available && requireNamespace("evaluate", quietly = TRUE)) {
          # User controls what they see in console (both default TRUE)
          echo_code <- Sys.getenv("BTW_ECHO_CODE", "TRUE") == "TRUE"
          echo_output <- Sys.getenv("BTW_ECHO_OUTPUT", "TRUE") == "TRUE"

          # Echo code to console if enabled
          if (echo_code) {
            cat("# BTW executing via MCP:\n", file = stdout())
            tryCatch({
              exprs <- parse(text = code)
              for (expr in exprs) {
                cat(paste0("> ", deparse(expr), "\n"), file = stdout())
              }
            }, error = function(e) {
              cat(paste0("> ", code, "\n"), file = stdout())
            })
          }

          # Use evaluate for complete output capture
          # keep_warning=NA and keep_message=NA let them display naturally while capturing
          result <- tryCatch({
            evaluate::evaluate(
              code,
              envir = .GlobalEnv,
              new_device = FALSE,
              stop_on_error = 1L,
              keep_warning = NA,      # Let warnings bubble to console naturally
              keep_message = NA       # Let messages bubble to console naturally
            )
          }, error = function(e) NULL)

          if (!is.null(result)) {
            # Single-pass extraction and echo (simplified, fixes bugs)
            outputs <- character()
            MAX_OUTPUT_SIZE <- 1000000  # 1MB limit
            total_size <- 0

            for (item in result) {
              # Check size limit
              if (total_size > MAX_OUTPUT_SIZE) {
                outputs <- c(outputs, "\n[Output truncated - exceeded 1MB limit]")
                break
              }

              if (inherits(item, "character")) {
                text <- paste(item, collapse = "")
                outputs <- c(outputs, text)
                total_size <- total_size + nchar(text)
                if (echo_output) cat(text, file = stdout())

              } else if (inherits(item, "simpleMessage")) {
                outputs <- c(outputs, item$message)
                total_size <- total_size + nchar(item$message)
                if (echo_output) cat(item$message, file = stdout())

              } else if (inherits(item, "simpleWarning")) {
                text <- paste0("Warning: ", item$message)
                outputs <- c(outputs, text)
                total_size <- total_size + nchar(text)
                # Not echoed - already visible naturally via keep_warning=NA

              } else if (inherits(item, "error")) {
                text <- paste0("Error: ", conditionMessage(item))
                outputs <- c(outputs, text)
                total_size <- total_size + nchar(text)
                # Echo with !! prefix (visible, avoids sticky bars)
                if (echo_output) cat("!! ", conditionMessage(item), "\n", file = stdout())

              } else if (inherits(item, "recordedplot")) {
                outputs <- c(outputs, "(Plot created in RStudio plots pane)")
              }
            }

            output_text <- if(length(outputs) > 0) paste(outputs, collapse = "") else "(No output produced)"

            # Inline auto-inspection with proper level support
            auto_context <- tryCatch({
              inspect_level <- Sys.getenv("BTW_INSPECT", "upgraded")

              if (inspect_level == "none") {
                NULL
              } else {
                # Build inspect code based on level (inline implementation of helper logic)
                inspect_code <- switch(inspect_level,
                  "minimal" = {
                    'objs <- ls(.GlobalEnv); if (length(objs) > 0) cat("\\n\\nAuto-context:", length(objs), "object", if(length(objs)!=1) "s" else "")'
                  },
                  "standard" = {
                    'objs <- ls(.GlobalEnv); if (length(objs) > 0) { recent <- tail(objs, 5); cat("\\n\\nAuto-context:", length(objs), "objects | Recent:", paste(recent, collapse=", ")) }'
                  },
                  "upgraded" = {
                    'objs <- ls(.GlobalEnv); if (length(objs) > 0) { recent <- tail(objs, 5); types <- sapply(recent, function(x) sprintf("%s(%s)", x, class(get(x))[1])); cat("\\n\\nAuto-context:", length(objs), "objects | Recent:", paste(types, collapse=", ")) }'
                  },
                  "verbose" = {
                    'objs <- ls(.GlobalEnv); if (length(objs) > 0) { recent <- tail(objs, 5); types <- sapply(recent, function(x) sprintf("%s(%s)", x, class(get(x))[1])); cat("\\n\\nAuto-context:", length(objs), "objects | All:", paste(objs, collapse=", "), "| Recent:", paste(types, collapse=", ")) }'
                  },
                  # Default to standard
                  'objs <- ls(.GlobalEnv); if (length(objs) > 0) { recent <- tail(objs, 5); cat("\\n\\nAuto-context:", length(objs), "objects | Recent:", paste(recent, collapse=", ")) }'
                )

                # Execute inspection in RStudio session
                inspect_result <- evaluate::evaluate(inspect_code, envir = .GlobalEnv, new_device = FALSE)

                # Extract cat() output
                context_text <- NULL
                if (length(inspect_result) > 0) {
                  for (item in inspect_result) {
                    if (inherits(item, "character") && length(item) > 0) {
                      context_text <- paste(item, collapse = "")
                      break
                    }
                  }
                }
                context_text
              }
            }, error = function(e) {
              NULL
            })

            return(paste0(
              paste(
                "Mode: session (with evaluate)",
                sprintf("Output:\n%s", output_text),
                "Note: Executed in connected RStudio session.",
                sep = "\n\n"
              ),
              if (!is.null(auto_context) && nchar(auto_context) > 0) auto_context else ""
            ))
          }
        }

        # Fallback to sendToConsole if evaluate not available
        if (rstudio_available) {
          rstudioapi::sendToConsole(code, execute = TRUE)
          return(paste(
            "Mode: session",
            "Output: Code executed in RStudio console. Check console for results.",
            "Note: Executed in connected RStudio session.",
            sep = "\n\n"
          ))
        }
      }

      # Subprocess mode
      temp_file <- tempfile(fileext = ".R")
      writeLines(code, temp_file)

      result <- tryCatch({
        sys_result <- system2(
          command = "timeout",
          args = c(as.character(timeout), "Rscript", temp_file),
          stdout = TRUE,
          stderr = TRUE
        )

        status <- attr(sys_result, "status")
        if (!is.null(status) && status == 124) {
          list(output = "", error = sprintf("Code execution timed out after %d seconds", timeout))
        } else {
          list(output = paste(sys_result, collapse = "\n"), error = NULL)
        }
      }, error = function(e) {
        list(output = "", error = paste("Execution error:", e$message))
      }, finally = {
        unlink(temp_file)
      })

      if (!is.null(result$error)) {
        paste("Mode: subprocess", sprintf("Error: %s", result$error), sep = "\n\n")
      } else {
        paste("Mode: subprocess", sprintf("Output:\n%s", result$output), sep = "\n\n")
      }
    }, error = function(e) {
      paste("Error:", e$message)
    })
  },
  name = "execute_r",
  description = "Execute R code with optional timeout protection. Runs in connected RStudio session if available, otherwise in safe subprocess.",
  arguments = list(
    code = ellmer::type_string("R code to execute"),
    timeout = ellmer::type_number("Timeout in seconds (only applies in subprocess mode)", required = FALSE)
  )
)

# Always add our custom execute_r (overrides any existing one)
filtered_tools$btw_tool_execute_r <- btw_tool_execute_r

# Add NEW save_plot tool
btw_tool_save_plot <- ellmer::tool(
  function(filename, path = ".", width = BTW_CONFIG$DEFAULT_PLOT_WIDTH,
           height = BTW_CONFIG$DEFAULT_PLOT_HEIGHT, dpi = BTW_CONFIG$DEFAULT_DPI, format = "png") {
    tryCatch({
      if (dev.cur() == 1) {
        return(BTW_CONFIG$ERRORS$NO_PLOT)
      }

      if (!dir.exists(path)) {
        dir.create(path, recursive = TRUE)
      }
      filepath <- file.path(path, filename)

      # Save based on format
      if (format == "png") {
        dev.copy(png, filepath, width = width * dpi, height = height * dpi)
        dev.off()
      } else if (format == "pdf") {
        dev.copy(pdf, filepath, width = width, height = height)
        dev.off()
      } else {
        return(format_message(BTW_CONFIG$ERRORS$UNSUPPORTED_FORMAT,
                             format = format,
                             formats = paste(BTW_CONFIG$SUPPORTED_FORMATS, collapse = ", ")))
      }

      return(format_message(BTW_CONFIG$SUCCESS$PLOT_SAVED, filepath = filepath))
    }, error = function(e) {
      return(paste("Error:", as.character(e$message)))
    })
  },
  name = "btw_tool_save_plot",
  description = "Save the current plot to a file",
  arguments = list(
    filename = ellmer::type_string(),
    path = ellmer::type_string(),
    width = ellmer::type_number(),
    height = ellmer::type_number(),
    dpi = ellmer::type_number(),
    format = ellmer::type_string()
  )
)

# Custom environment tool with configurable detail levels (inline logic)
btw_tool_env_describe_environment <- ellmer::tool(
  function(items = NULL, level = "upgraded", .intent = "Inspect environment") {

    valid_levels <- c("minimal", "standard", "upgraded", "verbose", "full")
    if (!level %in% valid_levels) {
      return(sprintf("Error: Invalid level '%s'. Valid levels: %s",
                     level, paste(valid_levels, collapse = ", ")))
    }

    if (level == "full") {
      tryCatch({
        return(btw::btw_this(.GlobalEnv, items = items))
      }, error = function(e) {
        return(paste("Error calling btw::btw_this:", e$message))
      })
    }

    tryCatch({
      all_objs <- ls(.GlobalEnv)

      objs <- if (is.null(items)) {
        all_objs
      } else {
        existing <- items[items %in% all_objs]
        missing <- items[!items %in% all_objs]

        if (length(missing) > 0 && length(existing) == 0) {
          return(sprintf("None of the specified items exist. Missing: %s",
                        paste(missing, collapse = ", ")))
        } else if (length(missing) > 0) {
          warning_msg <- sprintf("\nNote: Some items not found: %s",
                                paste(missing, collapse = ", "))
        } else {
          warning_msg <- ""
        }

        existing
      }

      if (length(objs) == 0) {
        return("Environment is empty")
      }

      # Generate output based on level (inline logic)
      n <- length(objs)
      result <- switch(level,
        "minimal" = {
          sprintf("Objects: %d %s", n, if(n == 1) "object" else "objects")
        },
        "standard" = {
          recent <- tail(objs, 5)
          sprintf("Objects: %d | Recent: %s", n, paste(recent, collapse = ", "))
        },
        "upgraded" = {
          recent <- tail(objs, 5)
          types <- sapply(recent, function(obj_name) {
            obj <- get(obj_name, envir = .GlobalEnv)
            sprintf("%s(%s)", obj_name, class(obj)[1])
          })
          sprintf("Objects: %d | Recent: %s", n, paste(types, collapse = ", "))
        },
        "verbose" = {
          all_names <- paste(objs, collapse = ", ")
          recent <- tail(objs, 5)
          types <- sapply(recent, function(obj_name) {
            obj <- get(obj_name, envir = .GlobalEnv)
            sprintf("%s(%s)", obj_name, class(obj)[1])
          })
          sprintf("Objects: %d | All: %s | Recent: %s", n, all_names, paste(types, collapse = ", "))
        },
        # Default fallback to upgraded
        {
          recent <- tail(objs, 5)
          types <- sapply(recent, function(obj_name) {
            obj <- get(obj_name, envir = .GlobalEnv)
            sprintf("%s(%s)", obj_name, class(obj)[1])
          })
          sprintf("Objects: %d | Recent: %s", n, paste(types, collapse = ", "))
        }
      )

      if (exists("warning_msg") && nchar(warning_msg) > 0) {
        result <- paste0(result, warning_msg)
      }

      return(result)

    }, error = function(e) {
      return(paste("Error during environment inspection:", e$message))
    })
  },

  name = "btw_tool_env_describe_environment",

  description = "List and describe environment objects with configurable detail level. Use level='full' for complete descriptions (token-heavy), or level='upgraded' (default) for lightweight summaries with type information.",

  arguments = list(
    items = ellmer::type_array(
      ellmer::type_string(),
      required = FALSE
    ),
    level = ellmer::type_string(
      "Detail level: minimal (count only) | standard (names) | upgraded (names+types, default) | verbose (all names + recent types) | full (complete btw::btw_this descriptions)",
      required = FALSE
    ),
    .intent = ellmer::type_string(
      "Intent of tool call",
      required = TRUE
    )
  )
)

# Complete editor_write tool with all 9 actions
btw_tool_editor_write <- ellmer::tool(
  function(text, action = "insert", line_number = NULL, start_line = NULL, end_line = NULL) {
    tryCatch({
      if (!rstudioapi::isAvailable()) {
        return(BTW_CONFIG$ERRORS$RSTUDIO_UNAVAILABLE)
      }

      result <- switch(action,
        "insert" = {
          rstudioapi::insertText(text = text)
          "Text inserted at cursor"
        },
        "replace" = {
          rstudioapi::setDocumentContents(text = text)
          "Document contents replaced"
        },
        "append" = {
          doc_context <- rstudioapi::getActiveDocumentContext()
          current_content <- paste(doc_context$contents, collapse = "\n")
          new_content <- paste(current_content, text, sep = "\n\n")
          rstudioapi::setDocumentContents(text = new_content)
          "Text appended to end of document"
        },
        "prepend" = {
          doc_context <- rstudioapi::getActiveDocumentContext()
          current_content <- paste(doc_context$contents, collapse = "\n")
          new_content <- paste(text, current_content, sep = "\n\n")
          rstudioapi::setDocumentContents(text = new_content)
          "Text prepended to beginning of document"
        },
        "insert_at_line" = {
          if (is.null(line_number)) {
            return("Error: line_number required for insert_at_line action")
          }

          doc_context <- rstudioapi::getActiveDocumentContext()
          current_lines <- doc_context$contents

          # Validate line number (inline)
          if (line_number <= 0) line_number <- 1
          if (line_number > length(current_lines)) {
            line_number <- length(current_lines) + 1
          }

          # Insert text at specified line
          if (line_number == 1) {
            new_lines <- c(text, current_lines)
          } else if (line_number > length(current_lines)) {
            new_lines <- c(current_lines, text)
          } else {
            new_lines <- c(current_lines[1:(line_number-1)], text,
                          current_lines[line_number:length(current_lines)])
          }

          rstudioapi::setDocumentContents(text = paste(new_lines, collapse = "\n"))
          paste("Text inserted at line", line_number)
        },
        "replace_selection" = {
          doc_context <- rstudioapi::getActiveDocumentContext()
          selection <- doc_context$selection[[1]]

          if (identical(selection$text, "")) {
            return("Error: No text selected. Please select text in RStudio editor before using replace_selection")
          }

          # Replace selected text
          rstudioapi::modifyRange(selection$range, text = text)
          paste("Replaced", nchar(selection$text), "characters of selected text")
        },
        "replace_lines" = {
          if (is.null(start_line) || is.null(end_line)) {
            return("Error: start_line and end_line required for replace_lines action")
          }

          doc_context <- rstudioapi::getActiveDocumentContext()
          current_lines <- doc_context$contents
          total_lines <- length(current_lines)

          # Validate and normalize line numbers (inline)
          if (start_line <= 0) start_line <- 1
          if (start_line > total_lines) start_line <- total_lines
          if (end_line <= 0) end_line <- 1
          if (end_line > total_lines) end_line <- total_lines

          # Ensure correct order
          if (start_line > end_line) {
            temp <- start_line
            start_line <- end_line
            end_line <- temp
          }

          # Replace lines
          if (start_line == 1 && end_line == total_lines) {
            new_lines <- strsplit(text, "\n", fixed = TRUE)[[1]]
          } else if (start_line == 1) {
            after_lines <- if (end_line < total_lines) current_lines[(end_line + 1):total_lines] else character(0)
            new_lines <- c(strsplit(text, "\n", fixed = TRUE)[[1]], after_lines)
          } else if (end_line == total_lines) {
            before_lines <- current_lines[1:(start_line - 1)]
            new_lines <- c(before_lines, strsplit(text, "\n", fixed = TRUE)[[1]])
          } else {
            before_lines <- current_lines[1:(start_line - 1)]
            after_lines <- current_lines[(end_line + 1):total_lines]
            new_lines <- c(before_lines, strsplit(text, "\n", fixed = TRUE)[[1]], after_lines)
          }

          rstudioapi::setDocumentContents(text = paste(new_lines, collapse = "\n"))
          paste("Replaced lines", start_line, "to", end_line, "(", end_line - start_line + 1, "lines )")
        },
        "comment_lines" = {
          if (is.null(start_line) || is.null(end_line)) {
            return("Error: start_line and end_line required for comment_lines action")
          }

          doc_context <- rstudioapi::getActiveDocumentContext()
          current_lines <- doc_context$contents
          total_lines <- length(current_lines)

          # Validate line numbers (inline)
          if (start_line <= 0) start_line <- 1
          if (start_line > total_lines) start_line <- total_lines
          if (end_line <= 0) end_line <- 1
          if (end_line > total_lines) end_line <- total_lines

          if (start_line > end_line) {
            temp <- start_line
            start_line <- end_line
            end_line <- temp
          }

          # Add # to the beginning of each line in range
          new_lines <- current_lines
          for (i in start_line:end_line) {
            if (!grepl("^\\s*#", current_lines[i])) {
              new_lines[i] <- paste0("# ", current_lines[i])
            }
          }

          rstudioapi::setDocumentContents(text = paste(new_lines, collapse = "\n"))
          paste("Commented lines", start_line, "to", end_line, "(", end_line - start_line + 1, "lines )")
        },
        "uncomment_lines" = {
          if (is.null(start_line) || is.null(end_line)) {
            return("Error: start_line and end_line required for uncomment_lines action")
          }

          doc_context <- rstudioapi::getActiveDocumentContext()
          current_lines <- doc_context$contents
          total_lines <- length(current_lines)

          # Validate line numbers (inline)
          if (start_line <= 0) start_line <- 1
          if (start_line > total_lines) start_line <- total_lines
          if (end_line <= 0) end_line <- 1
          if (end_line > total_lines) end_line <- total_lines

          if (start_line > end_line) {
            temp <- start_line
            start_line <- end_line
            end_line <- temp
          }

          # Remove # from the beginning of each line in range
          new_lines <- current_lines
          for (i in start_line:end_line) {
            new_lines[i] <- gsub("^\\s*#\\s?", "", current_lines[i])
          }

          rstudioapi::setDocumentContents(text = paste(new_lines, collapse = "\n"))
          paste("Uncommented lines", start_line, "to", end_line, "(", end_line - start_line + 1, "lines )")
        },
        paste("Error: Unknown action:", action, ". Available actions: insert, replace, append, prepend, insert_at_line, replace_selection, replace_lines, comment_lines, uncomment_lines")
      )

      return(result)
    }, error = function(e) {
      return(paste("Error:", as.character(e$message)))
    })
  },
  name = "btw_tool_editor_write",
  description = "Write text to RStudio editor with 9 flexible actions: insert (at cursor), replace (entire doc), append (to end), prepend (to start), insert_at_line (at specific line number), replace_selection (replace selected text), replace_lines (replace line range), comment_lines (add # to line range), uncomment_lines (remove # from line range)",
  arguments = list(
    text = ellmer::type_string("Text to write - not used for comment_lines/uncomment_lines actions", required = FALSE),
    action = ellmer::type_string("Action: insert, replace, append, prepend, insert_at_line, replace_selection, replace_lines, comment_lines, uncomment_lines", required = FALSE),
    line_number = ellmer::type_number("Line number for insert_at_line action (1-based)", required = FALSE),
    start_line = ellmer::type_number("Start line number for replace_lines action (1-based)", required = FALSE),
    end_line = ellmer::type_number("End line number for replace_lines action (1-based)", required = FALSE)
  )
)

# Replace BTW's environment tool with our custom version
filtered_tools$btw_tool_env_describe_environment <- btw_tool_env_describe_environment

# Combine filtered + new tools
final_tools <- c(
  filtered_tools,
  list(
    btw_tool_save_plot = btw_tool_save_plot,
    btw_tool_editor_write = btw_tool_editor_write
  )
)

# Report what we're serving
cat("BTW MCP Server v3.1 starting...\n", file = stderr())
cat(sprintf("Original tools: %d\n", length(all_tools)), file = stderr())
cat(sprintf("Excluded: %d\n", length(exclude_tools)), file = stderr())
cat(sprintf("Final tools: %d\n", length(final_tools)), file = stderr())
cat("v3 Features:\n", file = stderr())
cat("  - Complete bidirectional visibility (evaluate package)\n", file = stderr())
cat("  - No sticky console bars (keep_warning=NA)\n", file = stderr())
cat("  - Auto-inspection with 4 levels (minimal/standard/upgraded/verbose)\n", file = stderr())
cat("  - Configurable environment tool with 5 detail levels\n", file = stderr())
cat("Excluded tools:\n", file = stderr())
for (tool in exclude_tools) {
  cat(sprintf("  - %s\n", tool), file = stderr())
}
cat("\nStarting server...\n", file = stderr())

# Start the server
mcptools::mcp_server(tools = final_tools)
