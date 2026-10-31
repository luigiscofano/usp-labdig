import processing.core.PApplet;
import java.nio.file.Files;
import java.nio.file.Path;

/** Abre uma janela Processing real no Xvfb e exercita desenho e atalhos. */
public class GuardiaoVisualTest extends Guardiao {
    private int etapa = 0;
    @Override public void setup() { super.setup(); frameRate(30); }
    private void tecla(char valor) { key = valor; keyPressed(); }
    private void exigir(boolean condicao, String mensagem) {
        if (!condicao) throw new AssertionError(mensagem);
    }
    @Override public void draw() {
        try {
            super.draw();
            if (frameCount % 5 != 0) return;
            if (etapa == 0) {
                exigir(width == 960 && height == 600, "Tamanho da janela");
                saveFrame("build/processing/telas/jogando.png");
                tecla('1');
                for (int i=0; i<2000 && estadoJogo==JOGANDO; i++) gerarSimulacao();
                exigir(estadoJogo==VENCEU, "Vitoria visual");
            } else if (etapa == 1) {
                saveFrame("build/processing/telas/vitoria.png");
                tecla('2');
                for (int i=0; i<2000 && estadoJogo==JOGANDO; i++) gerarSimulacao();
                exigir(estadoJogo==PERDEU, "Derrota visual");
            } else if (etapa == 2) {
                saveFrame("build/processing/telas/derrota.png");
                tecla('x');
                exigir(csv != null && modoPlanilha, "Abrir CSV");
                String arquivo = csvPath;
                registrarLeitura(); tecla('x');
                exigir(Files.readAllLines(Path.of(arquivo)).size() >= 2, "Gravar CSV");
                tecla('s'); tecla('j');
                exigir(estadoJogo==JOGANDO && posicaoCm==400, "Reset pela tecla J");
                System.out.println("PASS Processing grafico: janela, tres telas, atalhos e CSV");
                exit();
            }
            etapa++;
        } catch (Throwable erro) { erro.printStackTrace(); System.exit(1); }
    }
    public static void main(String[] args) {
        PApplet.runSketch(new String[]{"GuardiaoVisualTest"}, new GuardiaoVisualTest());
    }
}
