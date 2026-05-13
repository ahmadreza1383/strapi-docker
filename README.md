# Strapi Docker Development Environment

This project provides a Docker-based development workflow for Strapi applications with prebuilt dependencies and optimized package mirrors.

## Why?

Installing Strapi dependencies repeatedly can be slow and unreliable, especially when:

- Internet access to npm/apk registries is limited
- CI/CD environments rebuild frequently
- Teams work with large Docker images
- Package downloads are unstable or blocked

To solve this, we use:

- Prebuilt Docker base images
- Cached dependencies inside the image
- Package mirrors such as Runflare / ArvanCloud
- VSCode local development with hot reload

---

# Development Workflow

## 1. Prebuilt Base Image

The base image already contains:

- Node.js
- Strapi dependencies
- Common build tools
- Preinstalled npm packages
- Optimized Alpine repositories

This avoids downloading dependencies every time the container starts.

Example:

```dockerfile
FROM my-strapi-base:latest
```

---

## 2. Using Mirror Registries

Instead of downloading packages directly from global registries, we use mirrors.

Examples:

- Runflare npm mirror
- ArvanCloud Alpine mirror

This improves:

- Download speed
- Stability
- Build reproducibility

Example Alpine repository:

```dockerfile
RUN echo "https://mirrors.arvancloud.ir/alpine/v3.23/main" > /etc/apk/repositories && \
    echo "https://mirrors.arvancloud.ir/alpine/v3.23/community" >> /etc/apk/repositories
```

Example npm registry:

```dockerfile
RUN npm config set registry https://registry.runflare.com/
```

---

# VSCode Development

The project is designed for local development using VSCode.

You can:

- Edit source files locally
- Mount the project into Docker
- Use hot reload
- See changes instantly using the development container

Example:

```bash
docker compose up
```

Then access:

```text
http://localhost:1337
```

---

# Development Base Image

We provide a dedicated development image that includes:

- Development dependencies
- Watch mode support
- Strapi dev server
- Faster rebuild process

This allows developers to:

- Start coding immediately
- Avoid reinstalling packages
- Share a consistent environment across the team

---

# Benefits

- Faster startup time
- Reduced dependency downloads
- Better experience in restricted networks
- Consistent development environment
- Easier onboarding for new developers
- Optimized Docker layer caching

---

# Recommended Workflow

1. Build or pull the base image
2. Start the development container
3. Open the project in VSCode
4. Develop locally
5. View changes instantly inside the container

---

# Example Commands

## Build development image

```bash
docker build -t strapi-dev .
```

## Start container

```bash
docker compose up
```

## Open shell

```bash
docker exec -it strapi bash
```

---

# Notes

- Use pinned dependency versions whenever possible
- Keep the base image updated regularly
- Use Docker layer caching for faster CI builds
- Prefer mirrors for npm and apk repositories
