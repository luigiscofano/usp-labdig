// Executa a lógica do sketch sem janela e sem dispositivo serial.
public class GuardiaoLogicTest {
    private static void exigir(boolean condicao, String mensagem) {
        if (!condicao) throw new AssertionError(mensagem);
    }
    public static void main(String[] args) {
        Guardiao jogo = new Guardiao();
        jogo.resetJogoParaSimulacao();
        exigir(jogo.posicaoCm == 400 && jogo.estadoJogo == jogo.JOGANDO, "Reset");
        jogo.modoSimulacao = 1;
        for (int i=0; i<2000 && jogo.estadoJogo==jogo.JOGANDO; i++) jogo.gerarSimulacao();
        exigir(jogo.estadoJogo==jogo.VENCEU, "Roteiro de vitoria");
        jogo.resetJogoParaSimulacao();
        jogo.modoSimulacao = 2;
        for (int i=0; i<2000 && jogo.estadoJogo==jogo.JOGANDO; i++) jogo.gerarSimulacao();
        exigir(jogo.estadoJogo==jogo.PERDEU, "Roteiro de derrota");
        jogo.resetJogoParaSimulacao();
        jogo.semaforo=0; jogo.variacaoCm=10; jogo.posicaoCm=100;
        jogo.verificarVitoriaOuDerrota();
        exigir(jogo.estadoJogo==jogo.JOGANDO, "Tolerancia de 10 cm");
        jogo.variacaoCm=11; jogo.posicaoCm=0;
        jogo.verificarVitoriaOuDerrota();
        exigir(jogo.estadoJogo==jogo.PERDEU, "Movimento invalido tem prioridade");
        jogo.resetJogoParaSimulacao(); jogo.semaforo=1;jogo.posicaoCm=20;
        jogo.verificarVitoriaOuDerrota();exigir(jogo.estadoJogo==jogo.JOGANDO,"Limite 20");
        jogo.posicaoCm=19;jogo.verificarVitoriaOuDerrota();exigir(jogo.estadoJogo==jogo.VENCEU,"Limite 19");
        System.out.println("PASS Processing: reset, vitoria, derrota e fronteiras");
    }
}
