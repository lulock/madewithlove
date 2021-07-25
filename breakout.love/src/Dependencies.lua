-- [[Following along Harvard's Games50 course. Instructed by Colton Ogden]]

-- push library from repo https://github.com/Ulydev/push
push = require 'lib/push'

Class = require 'lib/class'

require 'src/constants'

require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'

require 'src/Util'

require 'src/Paddle'
require 'src/Ball'
require 'src/Brick'
require 'src/LevelMaker'