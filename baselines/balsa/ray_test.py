import ray

# Initialize Ray with one CPU (simulates local mode behavior)
ray.init(num_cpus=1, _temp_dir="/tmp/ray")

@ray.remote
def compute_square(x):
    return x * x

numbers = [1, 2, 3, 4, 5]
results = ray.get([compute_square.remote(num) for num in numbers])

print("Squared numbers:", results)

# Shutdown Ray
ray.shutdown()