package network.froehlich.project2.calculator;

import network.froehlich.project2.parser.GameCollectionParser;
import network.froehlich.project2.pojo.Game;
import network.froehlich.project2.pojo.GameCollection;
import org.springframework.util.ResourceUtils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;
import java.util.stream.Stream;

public class Task2Calculator implements Calculator {

    Stream<String> input;

    final GameCollectionParser parser;

    public Task2Calculator(GameCollectionParser parser) throws IOException {
        this.parser = parser;
        File file = ResourceUtils.getFile("classpath:input.txt");
        this.input = Files.lines(file.toPath());
    }

    @Override
    public String getResult() {
        List<GameCollection> allGames = this.parser.parseGameCollections(this.input);

        int result = 0;
        for(GameCollection gameCollection : allGames) {
            int minimumRed = 0, minimumGreen = 0, minimumBlue = 0;
            for(Game game : gameCollection.games()) {
                minimumRed = Math.max(minimumRed, game.red());
                minimumGreen = Math.max(minimumGreen, game.green());
                minimumBlue = Math.max(minimumBlue, game.blue());
            }
            result += minimumRed * minimumBlue * minimumGreen;
        }

        return "" + result;
    }
}
