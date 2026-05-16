# Contributing to Flask EKS DevOps

Thank you for your interest in contributing! 🎉

## Author

**Saurabh Singh Rajput** — [@DevSars24](https://github.com/DevSars24)

## How to Contribute

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature-name`
3. **Commit** your changes: `git commit -m "feat: add amazing feature"`
4. **Push** to the branch: `git push origin feature/your-feature-name`
5. **Open** a Pull Request

## Commit Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code refactoring |
| `test` | Adding tests |
| `chore` | Maintenance tasks |
| `ci` | CI/CD changes |
| `infra` | Infrastructure changes |

## Development Setup

```bash
# Clone and install
git clone https://github.com/DevSars24/terraform-eks-devops.git
cd terraform-eks-devops
pip install -r requirements.txt

# Run tests
make test

# Run linters
make lint

# Format code
make format
```

## Code Standards

- Python code follows **PEP 8** (enforced by flake8)
- Code formatted with **Black** (line length: 100)
- All functions have **docstrings**
- Tests required for new features
- Terraform formatted with `terraform fmt`

## Pull Request Checklist

- [ ] Code follows project style guidelines
- [ ] Tests pass (`make test`)
- [ ] Linting passes (`make lint`)
- [ ] Documentation updated if needed
- [ ] Commit messages follow conventional commits
