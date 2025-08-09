Um clone do jogo Pong, feito em assembly do MIPS usando a ferramenta MARS 4.5

Trabalho desenvolvido para a disciplina de Arquitetura e Organização de Computadores

Para rodar:

NECESSARIO MARS 4.5

Conecte o bitmap display e coloque as seguintes configurações:
#Unit Width 8
#Unit Height 8
#Display Width 256
#Display Height 256
#Base address 0x10010000 (static data)

Conecte tambem o Keyboard and Display MMIO Simulator

Controles:
Player 1 - W Para cima e S Para baixo
Player 2 - O Para cima e L Para baixo
Nao segure os botoes apenas clique e não use CAPSLOCK!

a partida termina com o primeiro player que fizer 5 pontos
é necessario acompanhar o console onde fica o menu de opções e tambem a impressão do placar

Bom jogo!

(Se quiser modificar a velocidade pode alterar o valor da linha 121, quanto maior o valor mais lenta a bolinha)
