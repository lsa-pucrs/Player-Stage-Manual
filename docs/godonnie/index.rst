.. _godonnie:

===============
Donnie Programming Environment 
===============

Introduction
-------------
GoDonnie is a programming language that commands a robot called Donnie. This robot works in its own environment.
To open this environment it’s necessary to take a few steps. Open a Linux terminal and type ``donnie_player`` and press ``ENTER``.
After that, in order to start the module of GoDonnie’s commands type ``GoDonnie -t``. These expressions can be typed in capital letter or lower case.
Now, in the line of command, the user types the commands he wants. It’s possible to type one command per line or several commands in the same line.
After each line, the user should press ``ENTER``. For the robot to execute the commands, it’s necessary to press ``ESC``.
This way, the user can type a command and press ``ENTER`` and ``ESC``, or he can type one command per line, pressing ``ENTER`` to change lines, and only pressing ``ESC`` when he wants to run the commands. 
The GoDonnie language doesn’t difference capital letters to lower cases, and the commands can be typed with or without accentuation.
The robot always starts at the point 0,0 facing north. This position is located on the left bottom.
The commands in this manual are all in Portuguese.



GoDonnie Programming Language
-------------

************************************
GoDonnie User manual
************************************

Section 1: Leaving the programming terminal
############################################

Command:
    ``SAIR``

Subject-matter:
    None

Explanation:
    It closes the programming environment. It can only be used in the terminal.

**Example:**
    
::
    
    SAIR


Section 2: Declaration of variables
###################################
*Variable is an object that holds value. This variable can only receive integer values*

Command:
    ``CRIAR x``
Subject-matter:
    ``x`` is the variable that is going to be created. This variable receives integer values.
Explanation:
    There are 5 forms to create a variable:

    1. Create a variable;
    2. Create a variable and assign an initial value;
    3. Create a variable that receives an expression;
    4. Create a variable inside the command of repeat ``PARA``;
    5. Create a variable that will receive a value from another command, such as: ``COR`` and ``POS``.

    Variables hold only the last received values. They store only integer values. This way, if there is a comma result, only the integer part will be stored in the variable.

    There are rules for the name of the variables:

    - There are no difference between capital letter and lower case;
    - It can’t contain special characters. Exemple: *, @, #, +;
    - It can’t initiate with a number. Exemple: CRIAR 52abc is wrong.


**Example:**

    1. To create a variable without initial value, it’s possible to do:

    ::

        CRIAR A

    Creates a variable called A.

    ::

        A = 2

    When a variable is created it’s possible to assign directly a value. The variable called ``A`` will store the value 2.

    2. To create a variable with initial value, it’s possible to do:

    ::

        CRIAR B = 5

    Creates a variable called ``B`` and stores the value 5.

    3. To create a variable that receives an expression, it’s possible to do:

    ::

        CRIAR C = A + B

    Creates a variable called ``C`` that receives the value of the variable ``A`` added to the value of the variable ``B``. The result of variable ``C`` is 7.

    ::

        C = 1

    Changes the value of the variable ``C`` and stores the value 1, losing its previous value.

    4. To create a variable inside the command ``PARA`` (this command will be seen in section 10 of the manual), it’s possible to do:
        
    ::

        PARA CRIAR d = 0; d > 5; d = d +1 FAÇA
        PF 1
        FIM PARA

    The robot will take 5 steps forward.

    5. To create a variable that receives value from another command, it’s possible to do:

    ::

        CRIAR d = DISTANCIA F
        CRIAR c = COR VERDE
        CRIAR px = POS x

    The variable d is going to store the front distance from the robot to the object. The variable ``c`` is going to store the number of green objects. And the variable ``px`` is going to store the current position of the robot in the x axis. (The commands ``distância``, ``cor`` and ``pos`` will be seen in section 10 of the manual).

    ::

        G = 5

    It will return an error because the variable ``G`` was not created.

Section 3: Audio Commands
##########################
*Commands for manipulation and return of audio*


| **a)**
Command:
    ``FALAR x``

Subject-matter:
    ``x`` is a variable that must have been created previously.

Explanation:
    It speaks the content of the variable. This sound is issued by the robot or the virtual environment, it depends on which one is active.

**Example:**

    ::

        CRIAR x = 5
        FALAR x

    Will be spoken: 5

| **b)**
Command:
    ``FALAR “x”``

Subject-matter:
    ``x`` is a word or a phrase, that needs to be between quotation marks

Explanation:
    It speaks the word or phrase between quotation marks. This sound is issued by the robot or the virtual environment, it depends on which one is active.

**Example:**

    ::

        FALAR “hello”

    Will be spoken: hello

| **c)**
Command:
    ``SOM ligado``
    ``SOM desligado``

Subject-matter:
    It turns the audio on or off

Explanation:
    These commands turn on and off the audio from the robot or the virtual environment.

**Example:**

    ::

        SOM LIGADO
        SOM DESLIGADO


Section 4: Operators
######################
*They are operators that provide support for logical and mathematical expressions*

Command:
    Operators

Subject-matter:
    | *Mathematical:*
    | ``+ sum``
    | ``- subtraction``
    | ``* multiplication``
    | ``/ division``

    | *Comparators:*
    | ``<> different``
    | ``== equal``
    | ``< smaller``
    | ``> bigger``
    | ``<= smaller or equal``
    | ``>= bigger or equal``

    | *Assignment:*
    | ``= assignment``

Explanation:
    Operators are used to compare values or expressions.

**Example:**
    *To sum*

    ::

        Criar a = 2

    Creating the variable ``a`` and storing the value 2

    ::

        Criar b = 1

    Creating the variable ``b`` and storing the value 1

    ::

        Criar sum

    Creating the variable ``sum``

    ::

        sum = a + b

    Storing in ``sum`` the sum from variables ``a`` and ``b``

    ::

        Falar sum

    Will be spoken: 3

    *To divide*

    ::

        Criar c = 2

    Creating the variable ``c`` and storing the value 2

    ::

        Criar d = 2

    Creating the variable ``d`` and storing the value 2

    ::

        Criar division

    Creating the variable ``division``

    ::
    
        division = c / d

    Storing in ``division`` the division from variables ``c`` and ``d``

    ::

        Falar division

    Will be spoken: 1


Section 5: Movement Commands
##############################
*They are commands that move the robot in the environment*

| **a)**
Command:
    ``PF n``

Subject-matter:
    ``n`` is the number of steps. This command accepts only integer and positive numbers, or variables that store integer numbers, or mathematical expressions that result in integer numbers.

Explanation:
    It walks ``n`` steps forward

**Example:** 

    ::

        PF 5

    The robot will walk 5 steps forward

    ::
        
        CRIAR A = 10
        PF A

    The robot will walk 10 steps forward

    ::

        CRIAR A = 10
        CRIAR B = 20
        PF A + B

    The robot will walk 30 steps forward

    If the robot hits into something before it walks the number of steps, you will be informed: ``“I walked only X steps forward. I found an obstacle.”``

    ::

        PF -5

    When a negative number is typed as a command, the user will be informed that the robot walked 0 steps.

| **b)**
Command:
    ``PT n``

Subject-matter:
    ``n`` is the number of steps. This command accepts only integer and positive numbers, or variables that store integer numbers, or mathematical expressions that result in integer numbers.

Explanation:
    It walks ``n`` steps backward.

**Example:**

    ::

        PT 5

    The robot will walk 5 steps backward

    ::
    
        CRIAR A = 10
        PT A

    The robot will walk 10 steps backward

    ::

        CRIAR A = 10
        CRIAR B = 20
        PT A + B

    The robot will walk 30 steps backward

    If the robot hits into something before it walks the number of steps, you will be informed: ``“I walked only X steps backward. I found an obstacle.”``

    ::

        PT -5

    When a negative number is typed as a command, the user will be informed that the robot walked 0 steps.





Section 6: Rotation Commands
###############################
*The robot rotates without movement*

| **a)**
Command:
    ``GD n``

Subject-matter:
    ``n`` is the number of degrees. This command accepts only integer and positive numbers, or variables that store integer numbers, or mathematical expressions that result in integer numbers.

Explanation:
    Turns ``n`` degrees to the right. The robot does no displacement.

**Example:**

    ::

        GD 90

    The robot will turn 90 degrees to the right.

    ::

        CRIAR A = 45
        GD A

    The robot will turn 45 degrees to the right.

    ::

        CRIAR A = 80
        CRIAR B = 10
        GD A + B

    The robot will turn 90 degrees to the right.

    ::

        GD - 90

    The robot will turn 90 degrees to the left.


| **b)**
Command:
    ``GE n``

Subject-matter:
    ``n`` is the number of degrees. This command accepts only integer and positive numbers, or variables that store integer numbers, or mathematical expressions that result in integer numbers.

Explanation:
    Turns ``n`` degrees to the left. The robot does no displacement.

**Example:**

    ::

        GE 90

    The robot will turn 90 degrees to the left.

    ::

        CRIAR A = 45
        GE A

    The robot will turn 45 degrees to the left.

    ::

        CRIAR A = 80
        CRIAR B = 10
        GE A + B

    The robot will turn 90 degrees to the left.

    ::

        GE - 90

    The robot will turn 90 degrees to the right.


Section 7: Commands of Visualization of the Environment
#########################################################
*These are commands to get informations about the environment in which the robot is inserted. It’s not possible to store in variables the return from these commands*

| **a)**
Command:
    ``ESPIAR``

Subject-matter:
    None

Explanation:
    It returns the identification of the object, the approximate angle and the approximate distance between the robot and the identified object. The tracking for the identification of objects occurs from 90 degrees to the left to 90 degrees to the right from the front.

Example:               
    Let’s assume that the robot is in the position 2,3, facing north, and there’s a green obstacle in the position 0,5 and other red obstacle in the position 6,3.

    ::

        ESPIAR

    It will be spoken:

    ``To the 40 degrees in the left: 1 object of color green at 2 steps.`` ``To the 90 degrees in the right: 1 object of color red at 4 steps.``

    In case two objects are in the same degree, it will inform: ``To the 30 degrees in the left: 2 objects of color green, red at 17 steps.``


| **b)**
Command:
    ``ESTADO``

Subject-matter:
    None

Explanation:
    It returns the position in the X, Y axis and the angle from the robot. It also informs the last rotation or movement command that was typed before the command ESTADO.

**Example:**

    ::

        PF 3 ESTADO
    
    Let’s say the robot was at 0,0. The robot will walk 3 steps forward and it will inform: 
    ``“I walked 3 steps forward, command 1 was PF 3, walked 3, didn’t crash, position [3,0,0].”`` The number 3 corresponds to the X axis, the first 0 corresponds to the Y axis and the last 0 corresponds to the angle of the robot.

    In case the robot crashes into something and only completes 2 steps successfully, the command will return:
    ``”I walked 3 steps forward, command 1 was PF 3, walked 2, crashed, position [2,0,0].”``

    If there weren’t previous commands, it will return:
    ``“No command executed, position [0,0,0]".``


Section 8: Commands of Position and Perception of the Environment
################################################################
*These are commands to get informations about the environment in which the robot is inserted. It is possible to store in variables the return from these commands*

| **a)**
Command:
    ``DISTANCIA d``

Subject-matter:
    ``d`` is the direction of the robot sensor (``f`` - front; ``fd`` - right frontal; ``fe`` - left frontal; ``t`` - back; ``te`` - left rear; ``td`` - right rear).

Explanation:
    It returns the quantity of steps from the robot sensor to an obstacle, depending on the chosen direction.               

    There are three ways to use the DISTANCIA command:

    1. If the user wants to have a feedback, he should use the command ``FALAR`` with the command ``DISTANCIA``.
    2. If the user wants only to store in a variable.
    3. If the user wants to use it directly in another command, for example: ``SE`` (section 9), ``PARA`` (section 10), ``REPITA`` (section 10) or ``ENQUANTO`` (section 10).

    - DISTANCIA F returns the number of steps from the robot to an object detected by the front sensor of the robot.
    - DISTANCIA FD returns the number of steps from the robot to an object detected by the frontal right sensor of the robot.
    - DISTANCIA FE returns the number of steps from the robot to an object detected by the frontal left sensor of the robot.
    - DISTANCIA T returns the number of steps from the robot to an object detected by the back sensor of the robot.
    - DISTANCIA TD returns the number of steps from the robot to an object detected by the right rear sensor of the robot.
    - DISTANCIA TE returns the number of steps from the robot to an object detected by the left rear sensor of the robot.
                    
    If there aren’t obstacles, it returns the quantity of step that the sensor can identify, that usually is 60 steps.


**Example:**

    ::

        DISTANCIA F
        DISTANCIA FD
        DISTANCIA FE
        DISTANCIA T
        DISTANCIA TE
        DISTANCIA TD

    Assuming that the robot is in the position 0,0, facing north and there are obstacles in the following positions, the result will be:

    Obstacle in 0,3:

    ::

        FALAR DISTANCIA F

    Answer: 3 Steps

                    
    You can previously create a variable, and after use it to store what the command DISTANCIA will return:

    ::

        CRIAR d = DISTANCIA T

    It stores in the variable ``d`` the back distance from the robot to the obstacle that is directly behind it. Assuming that the robot is in the position 0,3 facing north and there is an obstacle in 0,0. The stored value in ``d`` will be 3.

    ::

        SE DISTANCIA F>3 ENTAO
        PF 1
        SENAO
        FALAR “It’s impossible to move forward”
        FIM SE

    In the example above, if the front distance from the robot is bigger than 3, the robot will move 1 step forward. If the distance is equal or smaller than 3, it will return: ``“It’s impossible to move forward”``

    ::

        ENQUANTO DISTANCIA F>3
        FAÇA
        PF 1
        FIM ENQUANTO

    In the example above, while the front distance from the robot to the object is bigger than 3, it will move 1 step forward.

| **b)**
Command:
    ``POS k``

Subject-matter:
    ``k`` is an axis of the Cartesian plane (X or Y) or angle (A).

Explanation:
    It returns the current position of the robot in the X axis or Y axis or the current angle of the robot.

    There are three ways to use the POS k command:

    1. If the user wants to have feedback, he should also use the command ``FALAR`` altogether with the command ``POS x``, ``POS y`` or ``POS a``;
    2. If the user wants only to store it in a variable;
    3. If the user wants to use it directly in another command, for example: ``SE`` (section 9), ``PARA`` (section 10), ``REPITA`` (section 10) or ``ENQUANTO`` (section 10).

Example:
    If the user wants to have a feedback, he can do as it follows:

    Assuming the robot is in the position 0,0 facing north:

    ::

        FALAR POS x

    It will be spoken 0

    ::

        FALAR POS y

    It will be spoken 0

    ::

        FALAR POS a

    It will be spoken 0

    If the user only wants to store the position value:

    ::

        CRIAR z = POS x

    The variable ``z`` has stored the value of the position of the robot in the x axis

    ::

        CRIAR b = POS y

    The variable ``b`` has stored the value of the position of the robot in the y axis

    ::

        CRIAR i = POS a 

    The variable ``i`` contains the angle of the robot

    If the user wants to use it inside other commands:

    ::

        SE POS b > 0 ENTÃO
        PF 5
        SENÃO
        PT 5
        FIM SE


| **c)**
Command:
    ``COR c``

Subject-matter:
    ``c`` is the color you want (blue, red, green)

Explanation:
    Verifies how many objects of a certain color the robot can identify at an angle of 180 degrees ahead of it.

    There are three ways to use the COR c command:

    1. If the user wants to have a feedback, he should use the command ``FALAR`` with the command ``COR``.
    2. If the user wants only to store in a variable.
    3. If the user wants to use it directly in another command, for example: ``SE`` (section 9), ``PARA`` (section 10), ``REPITA`` (section 10) or ``ENQUANTO`` (section 10).

**Example:**
    
    If the user wants to have a feedback, he can do as it follows:

    Assuming there is one green object and two blue objects:

    ::
                       
        FALAR COR azul

    It will be spoken 2

    ::

        FALAR COR verde

    It will be spoken 1

    If the user only wants to store the color value:

    ::
                        
        CRIAR A = COR AZUL

    The variable ``A`` stores the number of blue objects.

    ::

        CRIAR V = COR VERDE

    The variable ``V`` stores the number of green objects.

    If the user wants to use it inside other commands:

    ::
                        
        SE COR AZUL > 0 ENTÃO    
        FALAR “Number of blue objects”
        FALAR COR AZUL
        SENÃO
        FALAR "Couldn’t find blue objects"
        FIM SE

        SE COR VERDE > 0 ENTÃO
        FALAR “Number of green objects”
        FALAR COR VERDE
        SENÃO
        FALAR "Couldn’t find green objects"
        FIM SE


Section 9: Condition Commands
###############################
*These are conditional commands that allow the program to choose what will be executed, according to the stipulated condition*

| **a)**
Command: 
    | ``SE`` *expression logical operator expression*
    | ``ENTÃO`` *commands*
    | ``SENÃO`` *commands*
    | ``FIM SE``

Subject-matter:
    Expression = variable or expression

Explanation:
    Test if a condition is true and, if it is,executes the first line of commands, else executes the SENÃO line of commands.

Example:
    Assuming that, if the variable is lower than 4 the robot has to walk 5 steps forward, else it has to turn 45 degrees to the left:

    ::
                   
        CRIAR a = 0
        SE a<4
        ENTÃO PF 5
        SENÃO GE 45
        FIM SE


| **b)**
Command:               
    | ``SE`` *expression logical operator expression*
    | ``ENTÃO`` *commands*
    | ``FIM SE``

Subject-matter:
    Expression = variable or expression

Explanation:
    Test if a condition is true and, if it is, executes the first line of commands.

**Example:**

    ::
                       
        CRIAR a = 0
        SE a<4
        ENTÃO PF 5
        FIM SE

    If the variable ``a`` has a value smaller than 4 the robot will walk 5 steps forward

    
Section 10: Repeat commands
############################
*These are commands that allow one or more instructions to be executed a certain number of times*

| **a)**
Command: 
    | ``PARA`` *initialization; expression logical operator expression; increment or decrement*
    | ``FAÇA`` *commands*
    | ``FIM PARA``

Subject-matter:
    | Initialization: variable = an integer value

    Variable or expression logical operator variable or expression: variable or expression - logical operator - variable or expression.

    | Increment: variable + constant or variable + variable
    | Decrement: variable - constant or variable - variable

Explanation:
    Repeats the commands a certain number of times

Example:
    The example makes the robot to walk towards an obstacle that’s in front of him and after each step he says “hello”.

    ::

        CRIAR obstacle = DISTANCIA F
        PARA CRIAR x=1; x<=obstacle; x=x+1     
        FAÇA
        PF 1
        FALAR “hello”
        FIM PARA

The variable ``x`` will start with 1 as value, the robot will walk one step forward and will say “hello” while the value is smaller or equal the distance to the obstacle.


| **b)**
Command: 
    | ``REPITA n VEZES`` commands
    | ``FIM REPITA``

Subject-matter:
    ``n`` is the number of times that the commands will be repeated

Explanation:
    Repeats the commands ``n`` times

Example:

    ::

        REPITA 4 VEZES
        GD 90
        PF 2
        FIM REPITA
    
    Assuming the robot will start at the position 0,0 , the commands GD 90 and PF 2 will be repeated 4 times. The robot’s trajectory will look like a square.







GoDonnie Interpreter
-------------

modos de operacao, exemplos de uso


