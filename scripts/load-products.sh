#!/bin/bash

#!/bin/bash
./scripts/graphql-run.sh 'query { products(first: 5) { edges { node { id name slug } } } }'

