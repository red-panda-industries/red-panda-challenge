DOCKER_IMAGE_TAG = 'red-panda-challenge:latest'

task 'build' do
  sh "docker buildx build . -t #{DOCKER_IMAGE_TAG}"
end

task 'build:no-cache' do
  sh "docker buildx build . -t #{DOCKER_IMAGE_TAG} --no-cache"
end

task 'run' => 'build' do
  sh "docker run --rm -it -v ./db:/app/db -v ./log:/app/log #{DOCKER_IMAGE_TAG}"
end

task 'run:no-cache' => ['build:no-cache', 'run']

task 'clean' do
  sh "docker rmi #{DOCKER_IMAGE_TAG}"
end

task default: 'build'