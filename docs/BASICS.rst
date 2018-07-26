.. raw:: html

   <!---
   # Capítulo 2 - O Básico
   --->

2.1 - Important File Types
--------------------------

O Player/Stage é uma ferramenta de simulação de robôs, que compreende um programa chamado Player, que é uma camada de abstração de hardware. Isso quer dizer que ele conversa com os bits de hardware do robô (como uma garra ou uma câmera), e permite que você os controle com seu código, não precisando se importar em como as várias partes do robô funcionam. O Stage é um plugin do Player que recebe as instruções mandadas pelo Player e as transforma em uma simulação do seu robô. Ele também simula informações de sensores e manda para o Player, que por sua vez faz com que essas informações fiquem disponíveis para o seu código.

Desta maneira, a simulação é composta por três partes:
 - Seu código. Ele conversa com o Player.
 - O Player. Ele pega seu código e manda as instruções para um robô. Recebe as informações sensoriais do robô e manda para o seu código.
 - O Stage. Faz interface com o Player da mesma maneira que o hardware de um robô faria. Recebe instruções do Player e move a simulação de um robô em um mundo simulado.

No Player/Stage existem três tipos de arquivos que você precisa entender para continuar a compreensão do Player/Stage:
 - o arquivo .world
 - o arquivo .cfg (configuração)
 - o arquivo .inc (incluir)

O arquivo .world fala para o Player/Stage que coisas estão disponíveis para serem colocadas no mundo virtual. Nesse arquivo você descreve o robô, qualquer item que popule esse mundo e o layout do mesmo. O arquivo .inc segue a mesma sintaxe e formato do arquivo .world mas pode ser incluído. Então se existe um objeto que você pode querer usar em outros mundos, como o modelo de um robô, colocar a descrição do robô em um arquivo .inc faz com que seja mais fácil de copiá-lo. Também significa que, se algum dia você quiser mudar a descrição do seu robô, você só precisa fazê-la em um lugar e as suas múltiplas simulações também serão mudadas.
O arquivo .cfg é o que o Player lê para pegar todas as informações sobre o robô que você vai usar. Este arquivo diz ao Player quais drivers ele precisa usar para interagir com o robô. O arquivo .cfg diz para o Player como conversar com o driver, e como interpretar qualquer informação do driver para que esta possa ser apresentada para o seu código. Itens descritos no arquivo .world devem ser descritos no arquivo .cfg se você quiser que seu código tenha a capacidade de interagir com aquele item(como um robô), se você não precisa que o código interaja com o item então isto não é necessário. O arquivo .cfg faz todas essas especificações usando interfaces e drivers.

2.2 - Interfaces, Drivers and Devices
-------------------------------------

-  Drivers are pieces of code that talk directly to hardware. These are
   built in to Player so it is not important to know how to write these
   as you begin to learn Player/Stage. The drivers are specific to a
   piece of hardware so, say, a laser driver will be different to a
   camera driver, and also different to a driver for a different brand
   of laser. This is the same as the way that drivers for graphics cards
   differ for each make and model of card. Drivers produce and read
   information which conforms to an **interface**. The driver design is
   described in `Chapter 11 <DRIVERS.md>`__.
-  Interfaces are a set way for a driver to send and receive information
   from Player. Like drivers, interfaces are also built in to Player and
   there is a big list of them in the `Player
   manual <http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__interfaces.html>`__.
   They specify the syntax and semantics of how drivers and Player
   interact. The interface design is described in `Chapter
   10 <INTERFACES.md>`__.
-  A device is a driver that is bound to an interface so that Player can
   talk to it directly. This means that if you are working on a real
   robot that you can interact with a real device (laser, gripper,
   camera etc) on the real robot, in a simulated robot you can interact
   with their simulations.

The official documentation actually describes these three things quite
well with an
`example <http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__tutorial__devices.html>`__.
(Actually, the official documentation still refers to the depreciated
laser interface, but I've updated all the references in this manual to
use the new ranger interface.)

    Consider the ranger interface. This interface defines a format in
    which a planar range-sensor can return range readings (basically a
    list of ranges, with some meta-data). The ranger interface is just
    that: an interface. You can't do anything with it.

    Now consider the sicklms200 driver. This driver controls a SICK
    LMS200, which is particular planar range sensor that is popular in
    mobile robot applications. The sicklms200 driver knows how to
    communicate with the SICK LMS200 over a serial line and retrieve
    range data from it. But you don't want to access the range data in
    some SICK-specific format. So the driver also knows how to translate
    the retrieved data to make it conform to the format defined by the
    ranger interface.

    The sicklms200 driver can be bound to the ranger interface ... to
    create a device, which might have the following address:

    ``localhost:6665:ranger:0``

    The fields in this address correspond to the entries in the
    ``player_devaddr_t`` structure: host, robot, interface, and index.
    The host and robot fields (localhost and 6665) indicate where the
    device is located. The interface field indicates which interface the
    device supports, and thus how it can be used. Because you might have
    more than one ranger, the index field allows you to pick among the
    devices that support the given interface and are located on the
    given host:robot Other lasers on the same host:robot would be
    assigned different indexes.

The last paragraph there gets a bit technical, but don't worry. Player
talks to parts of the robot using ports (the default port is 6665), if
you're using Stage then Player and Stage communicate through these ports
(even if they're running on the same computer). All this line does is
tell Player which port to listen to and what kind of data to expect. In
the example it's laser data which is being transmitted on port 6665 of
the computer that Player is running on (localhost). You could just as
easily connect to another computer by using its IP address instead of
\`\`localhost''. The specifics of writing a device address in this way
will be described in `Chapter 4 <CFGFILES.md>`__

.. figure:: http://nojsstats.appspot.com/UA-66082425-1/player-stage-manual.readthedocs.org
   :alt: img

   img
