# This configuration defines two entirely separate services:
# 1. A dynamic Web Service (FastAPI backend).
# 2. A Static Site (Vue.js frontend) that proxies API calls to the backend.

services:
  # ----------------------------------------------------
  # 1. DYNAMIC WEB SERVICE (FastAPI Backend)
  # ----------------------------------------------------
  - type: web
    name: wotnot-backend
    
    # Python code is here
    rootDir: ./backend
    
    env: python
    
    # Install dependencies
    buildCommand: "pip install -r requirements.txt"
    
    # Start command for Uvicorn
    startCommand: "uvicorn wati.main:app --host 0.0.0.0 --port $PORT"
    
    # IMPORTANT: The staticPublishPath is REMOVED from the dynamic service
    
    envVars:
      - key: PYTHON_VERSION
        value: 3.12.3 
      - key: GEMINI_API_KEY
        sync: false 
      - key: DATABASE_URL 
        sync: false 
        
  # ----------------------------------------------------
  # 2. STATIC SITE SERVICE (Vue.js Frontend)
  # ----------------------------------------------------
  - type: static
    name: wotnot-frontend
    
    # Root directory for the Vue project (where package.json lives)
    rootDir: ./frontend/my-vue-app 
    
    # Command to install Node modules and build the Vue application
    buildCommand: "npm install && npm run build"
    
    # The directory where Vue places the final static files
    publishPath: ./dist
    
    # Environment Variables for the Frontend
    envVars:
      # Use a relative path, and Render will automatically proxy
      # this to the wotnot-backend service URL.
      - key: VUE_APP_API_URL 
        value: /api
