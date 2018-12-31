# Simulation of range-expansion in a mutation
# Vinay Ramasesh, 12/30/2018
# Initially written in MATLAB, 4/26/2015

import numpy as np
from random import choices

def time_step(simulation_state, simulation_params):
    
    # birth the normal individuals
    normal_individuals_stepped = give_birth(simulation_state['normals'], simulation_params['birth_rate'])        
    # migrate the normal individuals
    normal_individuals_stepped = migrate(normal_individuals_stepped, simulation_params['prob_migration'])

    if simulation_state['mutants'] is not None:
        # birth the mutant individuals
        mutant_individuals_stepped = give_birth(simulation_state['mutants'], simulation_params['birth_rate'])        
        # migrate the mutant individuals
        mutant_individuals_stepped = migrate(mutant_individuals_stepped, simulation_params['prob_migration'])
    
        # cull
        normal_individuals_stepped, mutant_individuals_stepped = cull_grid(normal_individuals_stepped, mutant_individuals_stepped, simulation_params['carrying_capacity'])
   
        return {'normals': normal_individuals_stepped, 'mutants': mutant_individuals_stepped}
    
    elif simulation_state['mutants'] is None:
        # cull
        normal_individuals_stepped, _ = cull_grid(normal_individuals_stepped, np.zeros(normal_individuals_stepped.shape, dtype = 'int'), simulation_params['carrying_capacity'])

        # decide if it's time to induce the mutation,
        # that is, if the wavefront has crossed the mutation_location
        wavefront_loc = wavefront_locations(normal_individuals_stepped)
        do_mutation = np.any([loc[1] == simulation_params['mutation_column'] for loc in wavefront_loc])

        if do_mutation:
            ## time to mutate
            mutation_loc = mutation_location(normal_individuals_stepped)
            mutant_individuals_stepped = np.zeros(normal_individuals_stepped.shape, dtype='int')                      

            mutant_individuals_stepped[mutation_loc[0]][mutation_loc[1]] += 1
            normal_individuals_stepped[mutation_loc[0]][mutation_loc[1]] -= 1

            return {'normals': normal_individuals_stepped, 'mutants': mutant_individuals_stepped}

        else:
            return {'normals': normal_individuals_stepped, 'mutants': None}


def check_done(simulation_state):
    """ checks if the simulation is done, defined by conditions:
    1. The wavefront has reached the end of the grid
    2. All individuals are dead 
    3. All mutants are dead"""
  
    normal_individuals = simulation_state['normals']
    
    if simulation_state['mutants'] is not None:
        # Mutation has occurred

        mutant_individuals = simulation_state['mutants']

        if np.max(mutant_individuals) == 0:
            # All the mutants are gone
            done = True
            success = False
        else: 
            # Mutants are still there,
            # Have they made it to the end?
            if np.max(normal_individuals[:,-1] + mutant_individuals[:,-1]) > 0:
                # Yes, have made it to end
                done = True
                success = True
            else:
                # No, have not made it to end
                done = False
                success = None
    else:
        # Mutation has not happened yet
        # if the mutation has not happened yet, the wavefront has not crossed
        #        the mutation location. So, the only way to to end is if 
        #        everyone has died.
        if np.max(normal_individuals) == 0:
            # All the people are gone
            done = True
            success = False
        else:
            # people are still there
            done = False
            success = None
    return [done, success]

def wavefront_locations(population_grid):
    """given an n_rows by n_column grid, gives the location of the 
    wavefront, or the furthest column occupied for each row"""

    n_rows = population_grid.shape[0]
    n_cols = population_grid.shape[1]
    wavefront_cols = np.empty(n_rows, dtype = 'int')

    for row_num, row in enumerate(population_grid):
        occupied = row > 0
        rev_occupied = list(reversed(occupied))
        if True in rev_occupied:
            wavefront_cols[row_num] = n_cols - rev_occupied.index(True) - 1
        else:
            wavefront_cols[row_num] = -1
    return list(enumerate(wavefront_cols))

def count_wavefront_individuals(population_grid):
    """ returns the number of individuals along the wavefront of a given population grid"""

    wavefront = wavefront_locations(population_grid)
  
    n_wavefront = [population_grid[wavefront_location] for wavefront_location in wavefront]

    return n_wavefront


def mutation_location(population_grid):
    """ Uniformly samples from individuals along the wavefront in the population_grid and returns its location """

    wavefront_locs = wavefront_locations(population_grid)
    n_wavefront_individuals = count_wavefront_individuals(population_grid)

    mutation_loc = choices(wavefront_locs, weights=n_wavefront_individuals)
    return mutation_loc[0]

def cull_singlecell(n_normals, n_mutants, carrying_capacity):
    """ if n_normals + n_mutants > carrying_capacity, randomly chooses only
    carrying_capacity of them to survive
    
    returns [n_normals, n_mutants], the numbers remaining after the cull
    """

    if n_normals + n_mutants <= carrying_capacity:
        return [n_normals, n_mutants]
    else:
        remaining_individuals = np.random.choice(['m']*n_mutants + ['n']*n_normals, size = carrying_capacity, replace = False)
        remaining_mutants = np.sum(remaining_individuals == 'm')
        remaining_normals = np.sum(remaining_individuals == 'n')

        return [remaining_normals, remaining_mutants] 

def cull_grid(normal_grid, mutant_grid, carrying_capacity):
    assert normal_grid.shape == mutant_grid.shape
    assert len(normal_grid.shape) == 2

    normal_grid_temp = np.empty(normal_grid.shape)
    mutant_grid_temp = np.empty(mutant_grid.shape)
    
    n_rows, n_cols = normal_grid.shape

    for row in range(n_rows):
        for col in range(n_cols):
            n_mutants = mutant_grid[row, col]
            n_normals = normal_grid[row, col]

            remaining_normals, remaining_mutants = cull_singlecell(n_normals, n_mutants, carrying_capacity)

            normal_grid_temp[row, col] = remaining_normals
            mutant_grid_temp[row, col] = remaining_mutants

    return normal_grid_temp, mutant_grid_temp

def give_birth(population_grid, birthrate):
    """ Each cell in the grid gives birth, with each individual 
    producing a poisson-distributed number of babies with the mean equal to birthrate """
    
    return np.random.poisson(population_grid * birthrate)

def migrate(population_grid, prob_migration):
    
    old_locations = grid_to_loc_list(population_grid)
    new_locations = [new_location(location, population_grid.shape, prob_migration) for location in old_locations]
    
    new_grid = loc_list_to_grid(new_locations, population_grid.shape)

    return new_grid

def grid_to_loc_list(population_grid):
    
    num_individuals = int(np.sum(population_grid))
    location_list = np.empty((num_individuals, 2), dtype = 'int')

    individual_num = 0 # counter
    for row in range(population_grid.shape[0]):
        for col in range(population_grid.shape[1]):
            for _ in range(population_grid[row][col]):
                location_list[individual_num,:] = np.array([row,col])
                individual_num += 1 
    return location_list

def loc_list_to_grid(loc_list, grid_shape):

    population_grid = np.zeros(grid_shape, dtype = 'int')
    for loc in loc_list:
        population_grid[loc[0], loc[1]] += 1 

    return population_grid

def new_location(old_location, grid_shape, prob_migration=0):
  
    whether_to_migrate = np.random.binomial(1, prob_migration)
    if not whether_to_migrate:
        return old_location
    else:

        possible_moves = np.array([[1,0],[0,1],[-1,0],[0,-1]])
        
        neighbors = np.array([np.array(old_location) + move for move in possible_moves])
        valid_neighbors = [neighbor for neighbor in neighbors if valid_location(neighbor, grid_shape)]
        return valid_neighbors[np.random.choice(len(valid_neighbors))]

def valid_location(location, grid_shape):
    """ Tests if the location is a valid location, i.e. inside the grid """
    
    x_valid = (location[0] >= 0 and location[0] < grid_shape[0])
    y_valid = (location[1] >= 0 and location[1] < grid_shape[1])

    return (x_valid and y_valid)

