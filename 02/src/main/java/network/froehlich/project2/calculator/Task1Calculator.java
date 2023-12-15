package network.froehlich.project2.calculator;

import network.froehlich.project2.parser.GameCollectionParser;
import network.froehlich.project2.pojo.Game;
import network.froehlich.project2.pojo.GameCollection;
import org.springframework.util.ResourceUtils;

import java.io.*;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class Task1Calculator implements Calculator {

    Stream<String> input;

    final GameCollectionParser parser;

    public Task1Calculator(GameCollectionParser parser) throws IOException {
        this.parser = parser;
        File file = ResourceUtils.getFile("classpath:input.txt");
        this.input = Files.lines(file.toPath());
    }

    @Override
    public String getResult() {
        List<GameCollection> allGames = this.parser.parseGameCollections(this.input);

        List<GameCollection> possibleGames = new ArrayList<>();
        for(GameCollection gameCollection : allGames) {
            boolean isPossible = true;
            for(Game game : gameCollection.games()) {
                if(game.red() > 12 || game.green() > 13 || game.blue() > 14) {
                    isPossible = false;
                }
            }
            if(isPossible) possibleGames.add(gameCollection);
        }

        int sum = 0;
        for(GameCollection gameCollection : possibleGames) {
            sum += gameCollection.nr();
        }

        return ""+sum;
    }
}
