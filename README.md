# Red Panda Challenge

Installation with Docker:

```bash
cd red-panda-challenge
```

Then, add Discord credentials to `.env`:
```bash
cp .env.example .env
editor .env
```

Build the Red Panda Challenge Docker container:
```bash
docker build . -t red-panda-challenge
```

Run the Red Panda Challenge Docker container:
```bash
docker run --rm -it -v ./db:/app/db -v ./log:/app/log red-panda-challenge
```
