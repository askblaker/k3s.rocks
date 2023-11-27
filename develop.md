# k3s.rocks

## Installation and Running Guide

### Prerequisites

Python 3 or Docker

## Python only (see bottom for Docker)

### Step 1: Clone the Repository

```bash
git clone https://github.com/askblaker/k3s.rocks.git
```

### Step 2: Navigate to the Project Directory

```bash
cd k3s.rocks
```

### Step 3: Setup virtual environment (optional but recommended)

```bash
python -m venv .venv
```

### Step 4: Activate the virtual environment (if installed)
```bash
source ./.venv/bin/activate
```

### Step 5: Install dependencies
```bash
pip install -r requirements.txt
```

### Step 6: Run the development server
```bash
mkdocs serve
```

### Step 7: Access the Application/Documentation

Open your web browser and navigate to http://localhost:8000

## Docker
Replace steps 3-6 with:

### Step 1: Build container 
```bash
docker build . -t k3sdocs
```

### Step 2: Run container mounted to directory
```bash
docker run -v ${PWD}:/src -p 8000:8000 k3sdocs 
```
