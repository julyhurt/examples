// TODO(jlewi): We should tag the image latest and then
// use latest as a cache so that rebuilds are fast
// https://cloud.google.com/cloud-build/docs/speeding-up-builds#using_a_cached_docker_image
{
	
	"steps": [      
    {
      "id": "pull-cpu",
      "name": "gcr.io/cloud-builders/docker",
      "args": ["pull", "gcr.io/kubeflow-examples/code-search:latest"],
      "waitFor": ["-"],
    },
    {
      "id": "build-cpu",
      "name": "gcr.io/cloud-builders/docker",
      "args": ["build", "-t", "gcr.io/kubeflow-examples/code-search:" + std.extVar("tag"), 
             	 "--label=git-versions=" + std.extVar("gitVersion"), 
               "--build-arg", "BASE_IMAGE_TAG=1.11.0",
               "--file=docker/t2t/Dockerfile", 
               "--cache-from=gcr.io/kubeflow-examples/code-search:latest",
               "."],
      "waitFor": ["pull-cpu"],
    },
    {
      "id": "tag-cpu",
      "name": "gcr.io/cloud-builders/docker",
      "args": ["tag", "gcr.io/kubeflow-examples/code-search:" + std.extVar("tag"), 
               "gcr.io/kubeflow-examples/code-search:latest",],
      "waitFor": ["build-cpu"],
    },    
    {
      "id": "pull-gpu",
      "name": "gcr.io/cloud-builders/docker",
      "args": ["pull", "gcr.io/kubeflow-examples/code-search-gpu:latest"],
      "waitFor": ["-"],
    },
    {
      "id": "build-gpu",
      "name": "gcr.io/cloud-builders/docker",      
      "args": ["build", "-t", "gcr.io/kubeflow-examples/code-search-gpu:" + std.extVar("tag"), 
             	 "--label=git-versions=" + std.extVar("gitVersion"), 
               "--build-arg", "BASE_IMAGE_TAG=1.11.0-gpu",
               "--file=docker/t2t/Dockerfile", 
               "--cache-from=gcr.io/kubeflow-examples/code-search-gpu:latest",
               "."],
      "waitFor": ["pull-gpu"],
    },    
    {
      "id": "tag-gpu",
      "name": "gcr.io/cloud-builders/docker",
      "args": ["tag", "gcr.io/kubeflow-examples/code-search-gpu:" + std.extVar("tag"), 
               "gcr.io/kubeflow-examples/code-search-gpu:latest",],
      "waitFor": ["build-gpu"],
    },
    {
      "id": "pull-dataflow",
      "name": "gcr.io/cloud-builders/docker",
      "args": ["pull", "gcr.io/kubeflow-examples/code-search-dataflow:latest"],
      "waitFor": ["-"],
    },
    {
      "id": "build-dataflow",
      "name": "gcr.io/cloud-builders/docker",
      "args": ["build", "-t", "gcr.io/kubeflow-examples/code-search-dataflow:" + std.extVar("tag"), 
               "--label=git-versions=" + std.extVar("gitVersion"),
               "--file=docker/t2t/Dockerfile.dataflow", 
               "--cache-from=gcr.io/kubeflow-examples/code-search-dataflow:latest",
               "."],
      "waitFor": ["pull-dataflow"],
    },
    {
      "id": "tag-dataflow",
      "name": "gcr.io/cloud-builders/docker",
      "args": ["tag", "gcr.io/kubeflow-examples/code-search-dataflow:" + std.extVar("tag"), 
               "gcr.io/kubeflow-examples/code-search-dataflow:latest",],
      "waitFor": ["build-dataflow"],
    },
  ],
  "images": ["gcr.io/kubeflow-examples/code-search:" + std.extVar("tag"), 
             "gcr.io/kubeflow-examples/code-search:latest", 
             "gcr.io/kubeflow-examples/code-search-gpu:" + std.extVar("tag"),
             "gcr.io/kubeflow-examples/code-search-gpu:latest",
             "gcr.io/kubeflow-examples/code-search-dataflow:" + std.extVar("tag"),
             "gcr.io/kubeflow-examples/code-search-dataflow:latest"],
}