""" vary start location of mutation """

import numpy as np
from src import mutations
from yaml import load

with open('config.yaml', 'r') as f:
    config = load(f)

simulation_params = config['simulation_params']
n_repetitions = config['n_repetitions']

mutation_start = config['mutation_locations']['start']
mutation_stop = config['mutation_locations']['stop']
mutation_step = config['mutation_locations']['step']

mutation_column_range = np.arange(start=mutation_start,stop=mutation_stop,step=mutation_step)

for mutation_column in mutation_column_range:

    simulation_params['mutation_column'] = mutation_column

    for repetition in np.arange(n_repetitions):

        print('Repetition {}'.format(repetition))
        # create the earth
        earth_normal = np.zeros((simulation_params['n_rows'], simulation_params['n_cols']), dtype='int')

        # randomly populate with one normal individual
        spawn_row = np.random.randint(simulation_params['n_rows'])
        spawn_col = 0
        earth_normal[spawn_row, spawn_col] = 1

        simulation_state = {'normals': earth_normal, 'mutants': None}

        simulation_done = False
        while not simulation_done:
            simulation_state = mutations.time_step(simulation_state, simulation_params)
            
            done_check = mutations.check_done(simulation_state)
            simulation_done = done_check[0]
            simulation_success = done_check[1]
        
        print(simulation_success)
        print(simulation_state['normals'])
        print(simulation_state['mutants'])

