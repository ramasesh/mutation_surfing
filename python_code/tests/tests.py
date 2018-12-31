import numpy as np
from mutations import check_done

print("Testing check_done() method")

normals = np.zeros((10,5))
normals[4,4] = 1

print(check_done(normals, None))
           
mutants = np.zeros((10,5))

print(check_done(normals, mutants))
# should return [True, False] since all the mutants are dead

mutants[2,2] = 1
print(check_done(normals, mutants))
# should return [True, True] since mutants are there and we've reached the end
