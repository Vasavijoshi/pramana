#!/usr/bin/env bash
# Pramāṇa — Sprint 0 scaffold script
# Run this from inside the empty `pramana/` folder you created and opened in Cursor.
set -euo pipefail

echo "Scaffolding Pramāṇa repo structure..."

# ── src/ package ─────────────────────────────────────────────
mkdir -p src/pramana/{config,corpus,rubric,schemas,utils}
for d in config corpus rubric schemas utils; do
  touch "src/pramana/${d}/__init__.py"
done
touch src/pramana/__init__.py

# ── data ──────────────────────────────────────────────────────
mkdir -p data/{raw,processed,structured,index}
for d in raw processed structured; do
  touch "data/${d}/.gitkeep"
done
echo "data/index/*" > data/index/.gitkeep_placeholder && rm data/index/.gitkeep_placeholder
touch data/index/.gitkeep

# ── experiments / notebooks ──────────────────────────────────
mkdir -p experiments notebooks
touch experiments/.gitkeep notebooks/.gitkeep

# ── tests ─────────────────────────────────────────────────────
mkdir -p tests/{unit,integration,fixtures}
touch tests/__init__.py tests/unit/__init__.py tests/integration/__init__.py
touch tests/fixtures/.gitkeep

# ── evaluation ────────────────────────────────────────────────
mkdir -p evaluation/{datasets,reports}
touch evaluation/datasets/.gitkeep evaluation/reports/.gitkeep

# ── docs (copy in your finalized docs here manually — see note below) ─
mkdir -p docs

# ── outputs / logs / scripts ──────────────────────────────────
mkdir -p outputs logs scripts
touch outputs/.gitkeep logs/.gitkeep

# ── frontend / backend placeholders ──────────────────────────
mkdir -p frontend backend
touch frontend/.gitkeep backend/.gitkeep

# ── root files ────────────────────────────────────────────────
touch .env.example

cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/

# Data & logs (raw/processed data should not bloat git history by default)
data/index/*
!data/index/.gitkeep
logs/*
!logs/.gitkeep
outputs/*
!outputs/.gitkeep

# Env
.env

# Editor
.vscode/
.idea/
.DS_Store

# mypy/ruff/pytest caches
.mypy_cache/
.ruff_cache/
.pytest_cache/
EOF

cat > pyproject.toml << 'EOF'
[build-system]
requires = ["setuptools>=68", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "pramana"
version = "0.1.0"
description = "AI-powered legal citation verification system"
requires-python = ">=3.11"
dependencies = [
    "pydantic>=2.0",
    "python-dotenv>=1.0",
    "pyyaml>=6.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0",
    "black>=24.0",
    "ruff>=0.5",
    "isort>=5.13",
    "mypy>=1.10",
    "pre-commit>=3.7",
]

[tool.setuptools.packages.find]
where = ["src"]

[tool.black]
line-length = 100
target-version = ["py311"]

[tool.isort]
profile = "black"
line_length = 100

[tool.ruff]
line-length = 100
target-version = "py311"

[tool.mypy]
python_version = "3.11"
strict = true
mypy_path = "src"
EOF

cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/psf/black
    rev: 24.4.2
    hooks:
      - id: black

  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.5.0
    hooks:
      - id: ruff
        args: [--fix]

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.10.0
    hooks:
      - id: mypy
        additional_dependencies: [pydantic]
EOF

echo ""
echo "✅ Structure created."
echo ""
echo "Next steps:"
echo "  1. python3.11 -m venv .venv && source .venv/bin/activate"
echo "  2. pip install -e '.[dev]'"
echo "  3. pre-commit install"
echo "  4. git init && git add . && git commit -m 'Sprint 0: repo scaffold'"
echo "  5. Copy your README.md, ARCHITECTURE.md, RUBRIC.md, DECISION_LOG.md,"
echo "     EVALUATION.md, ROADMAP.md into docs/ (and README.md into repo root)"
