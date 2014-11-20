STALE_POS = { [0, 0] => [King, :black],
              [0, 7] => [King, :white],
              [5, 1] => [Queen, :white] }

ONLY_KINGS = {[0, 0] => [King, :white],
              [7, 7] => [King, :black]}

KINGS_AND_KNIGHT = {[0, 0] => [King, :white],
                    [7, 7] => [King, :black],
                    [4, 4] => [Knight, :white]}

KINGS_AND_BISHOP = {[0, 0] => [King, :white],
                    [7, 7] => [King, :black],
                    [5, 4] => [Bishop, :white]}

BAD_BISHOPS = {[0, 0] => [King, :white],
               [7, 7] => [King, :black],
               [5, 4] => [Bishop, :white],
               [2, 3] => [Bishop, :black]}

GOOD_BISHOPS = {[0, 0] => [King, :white],
               [7, 7] => [King, :black],
               [5, 4] => [Bishop, :white],
               [2, 4] => [Bishop, :black]}
