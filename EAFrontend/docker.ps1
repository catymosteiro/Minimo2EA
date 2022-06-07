flutter build web --dart-define=API_URL=https://eaapitemp.chickenkiller.com
docker build -t paubaguer/ea-frontend:latest .
docker push paubaguer/ea-frontend:latest