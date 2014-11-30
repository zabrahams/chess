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

EN_PASS =    {[0, 0]=>[Rook, :white],
              [1, 0]=>[Knight, :white],
              [2, 0]=>[Bishop, :white],
              [3, 0]=>[Queen, :white],
              [4, 0]=>[King, :white],
              [5, 0]=>[Bishop, :white],
              [6, 0]=>[Knight, :white],
              [7, 0]=>[Rook, :white],
              [0, 1]=>[Pawn, :white],
              [2, 1]=>[Pawn, :white],
              [3, 1]=>[Pawn, :white],
              [4, 1]=>[Pawn, :white],
              [5, 1]=>[Pawn, :white],
              [6, 1]=>[Pawn, :white],
              [7, 1]=>[Pawn, :white],
              [1, 4]=>[Pawn, :white],
              [0, 6]=>[Pawn, :black],
              [1, 6]=>[Pawn, :black],
              [2, 6]=>[Pawn, :black],
              [3, 6]=>[Pawn, :black],
              [4, 6]=>[Pawn, :black],
              [5, 6]=>[Pawn, :black],
              [6, 6]=>[Pawn, :black],
              [7, 6]=>[Pawn, :black],
              [0, 7]=>[Rook, :black],
              [1, 7]=>[Knight, :black],
              [2, 7]=>[Bishop, :black],
              [3, 7]=>[Queen, :black],
              [4, 7]=>[King, :black],
              [5, 7]=>[Bishop, :black],
              [6, 7]=>[Knight, :black],
              [7, 7]=>[Rook, :black]}
