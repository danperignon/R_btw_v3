# BTW MCP Server Configuration
# Central configuration for all server constants and settings
# Source this file to access configuration values

# Execution Settings
BTW_CONFIG <- list(
  # Timeout Settings
  DEFAULT_TIMEOUT = 30,          # Default execution timeout in seconds
  MAX_TIMEOUT = 600,             # Maximum allowed timeout (10 minutes)
  MIN_TIMEOUT = 1,               # Minimum allowed timeout

  # Socket Settings
  SOCKET_CACHE_TIMEOUT = 5,      # How often to check for socket (seconds)
  SOCKET_PATH = "/tmp",          # Where to look for mcptools sockets
  SOCKET_PATTERN = "^mcptools-socket",  # Socket file pattern

  # Plot Settings
  DEFAULT_PLOT_WIDTH = 7,        # Default plot width in inches
  DEFAULT_PLOT_HEIGHT = 5,       # Default plot height in inches
  DEFAULT_DPI = 300,             # Default DPI for PNG export
  SUPPORTED_FORMATS = c("png", "pdf"),  # Supported plot formats

  # Editor Settings
  MAX_LINE_LENGTH = 1000,        # Maximum characters per line in editor
  TAB_WIDTH = 2,                 # Default tab width for R code

  # Tool Exclusions (tools that Claude handles better)
  EXCLUDE_TOOLS = c(
    "btw_tool_files_list_files",      # Use: ls, Glob
    "btw_tool_files_read_text_file",  # Use: Read
    "btw_tool_files_write_text_file", # Use: Write
    "btw_tool_files_code_search",     # Use: Grep
    "btw_tool_web_read_url"           # Use: WebFetch
  ),

  # Error Messages
  ERRORS = list(
    NO_CODE = "Error: Code must be a non-empty string",
    INVALID_TIMEOUT = "Error: Timeout must be a positive number between {min} and {max} seconds",
    NO_PLOT = "Error: No active plot to save",
    UNSUPPORTED_FORMAT = "Error: Unsupported format: {format}. Supported formats: {formats}",
    RSTUDIO_UNAVAILABLE = "Error: RStudio not available. Ensure rstudioapi is installed and you're running in RStudio.",
    NO_SELECTION = "Error: No text selected. Please select text in RStudio editor before using replace_selection",
    MISSING_LINE_NUMBER = "Error: {param} required for {action} action",
    UNKNOWN_ACTION = "Error: Unknown action: {action}. Available actions: {actions}"
  ),

  # Success Messages
  SUCCESS = list(
    PLOT_SAVED = "Plot saved to: {filepath}",
    TEXT_INSERTED = "Text inserted at cursor",
    DOCUMENT_REPLACED = "Document contents replaced",
    TEXT_APPENDED = "Text appended to end of document",
    TEXT_PREPENDED = "Text prepended to beginning of document",
    LINE_INSERTED = "Text inserted at line {line}",
    SELECTION_REPLACED = "Replaced {count} characters of selected text",
    LINES_REPLACED = "Replaced lines {start} to {end} ({count} lines)",
    LINES_COMMENTED = "Commented lines {start} to {end} ({count} lines)",
    LINES_UNCOMMENTED = "Uncommented lines {start} to {end} ({count} lines)"
  ),

  # Server Messages
  SERVER_MESSAGES = list(
    STARTING = "BTW MCP Server v3 starting...",
    TOOL_COUNT = "Original tools: {count}",
    EXCLUDED_COUNT = "Excluded: {count}",
    FINAL_COUNT = "Final tools: {count}",
    OPTIMIZATION_HEADER = "Performance optimizations:",
    CACHE_ENABLED = "  - Socket connection caching ({seconds}-second cache)",
    HANDLERS_EXTRACTED = "  - Extracted execution handlers",
    CONSTANTS_LOADED = "  - Configuration constants loaded",
    EXCLUDED_HEADER = "Excluded tools:",
    SERVER_READY = "Starting server..."
  ),

  # Attribution Messages
  ATTRIBUTION = "# BTW executing via MCP:",
  R_PROMPT = "> ",

  # Execution Modes
  MODE_SESSION = "session",
  MODE_SUBPROCESS = "subprocess",

  # Status Codes
  STATUS_SUCCESS = "success",
  STATUS_ERROR = "error",
  STATUS_TIMEOUT = "timeout"
)

# Helper function to format messages with placeholders
format_message <- function(template, ...) {
  args <- list(...)
  for (name in names(args)) {
    template <- gsub(paste0("\\{", name, "\\}"), args[[name]], template)
  }
  template
}

# Validate configuration on load
validate_config <- function(config = NULL) {
  if (is.null(config)) config <- BTW_CONFIG
  errors <- character()

  if (config$MIN_TIMEOUT >= config$MAX_TIMEOUT) {
    errors <- c(errors, "MIN_TIMEOUT must be less than MAX_TIMEOUT")
  }

  if (config$DEFAULT_TIMEOUT < config$MIN_TIMEOUT ||
      config$DEFAULT_TIMEOUT > config$MAX_TIMEOUT) {
    errors <- c(errors, "DEFAULT_TIMEOUT must be between MIN_TIMEOUT and MAX_TIMEOUT")
  }

  if (config$SOCKET_CACHE_TIMEOUT <= 0) {
    errors <- c(errors, "SOCKET_CACHE_TIMEOUT must be positive")
  }

  if (length(errors) > 0) {
    stop("Configuration validation failed:\n", paste("  -", errors, collapse = "\n"))
  }

  invisible(TRUE)
}

# Validate on source
validate_config()

# Export main config object
BTW_CONFIG
