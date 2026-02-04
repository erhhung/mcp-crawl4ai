# Use official Playwright image with browsers already installed
FROM mcr.microsoft.com/playwright/python:v1.58.0-noble AS base

# Set working directory
WORKDIR /app

# Set environment variables for Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install -r requirements.txt

# Copy application code
COPY . .

# Ensure app dir is owned by Playwright user
RUN chown -R pwuser:pwuser /app

# Switch to non-root user in Playwright image
USER pwuser

# Set environment variables
ENV PYTHONPATH=/app \
    CRAWL4AI_MCP_LOG=INFO

# Expose volume mount points
VOLUME ["/app/crawls", "/app/test_crawls"]

# Default command runs the MCP server
CMD ["python", "-m", "crawler_agent.mcp_server"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import crawler_agent.mcp_server; print('OK')" || exit 1

# Labels for metadata
LABEL maintainer="crawler_agent" \
    description="Crawl4AI MCP Server - Web scraping and crawling tools for AI agents" \
    version="1.0.0"
