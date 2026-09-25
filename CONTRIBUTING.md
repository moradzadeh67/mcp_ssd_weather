# Contributing to MCP SSD Weather

Thank you for your interest in contributing to MCP SSD Weather! We welcome contributions from developers of all skill levels.

---

## 🚀 Getting Started

1. **Fork the repository** on GitHub.
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/mcp_ssd_weather.git
   cd mcp_ssd_weather
   ```
3. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```
4. **Verify your environment:**
   ```bash
   flutter doctor
   ```

---

## 🐛 Opening an Issue

Before creating a new issue, please search the existing issues to ensure it hasn't already been reported.

- **Bug Reports:** Include clear steps to reproduce, expected vs. actual behavior, screenshots, and environment details (Flutter version, OS).
- **Feature Requests:** Explain the problem your proposed feature solves, alternative solutions considered, and any relevant context.

---

## 🔀 Submitting a Pull Request (PR)

1. **Create a branch** from the default branch (usually `main`):
   ```bash
   git checkout -b feat/add-weather-chart
   # or
   git checkout -b fix/search-case-sensitivity
   ```
2. **Branch Naming Conventions:**
   - `feat/` — New feature
   - `fix/` — Bug fix
   - `docs/` — Documentation changes
   - `refactor/` — Code refactoring
   - `chore/` — Build or toolchain updates

3. **Commit Messages** — Follow Conventional Commits:
   - `feat: add hourly forecast chart`
   - `fix: resolve search case sensitivity issue`
   - `docs: update CONTRIBUTING.md`

4. **Submit your PR:**
   - Push your branch to your fork and create a Pull Request against the default branch.
   - Fill out the PR template completely, referencing any related issue numbers (e.g., `Closes #12`).

---

## 🎨 Coding Standards

Please ensure your code adheres to standard Dart and Flutter guidelines:
- Follow the official [Effective Dart](https://dart.dev/effective-dart) style guide.
- Run static analysis and formatting before committing:
  ```bash
  flutter analyze
  dart format .
  ```
- Keep code clean, readable, and appropriately commented where logic is non-obvious.

---

## 🧪 Running Tests

Always ensure existing tests pass before submitting a Pull Request:
```bash
flutter test
```
If you are adding a new feature, please include corresponding unit or widget tests whenever feasible.

---

## 📜 Code of Conduct

MCP SSD Weather is an open, welcoming community. We expect all contributors to:
- Be respectful, courteous, and constructive in all interactions.
- Focus on what is best for the community and the project.
- Respect differing viewpoints and constructive feedback.

Instances of unacceptable behavior may be reported to the project maintainers.
