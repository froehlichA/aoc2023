package network.froehlich.project2.parser;

import network.froehlich.project2.pojo.Game;
import network.froehlich.project2.pojo.GameCollection;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class GameCollectionParser {

    public List<GameCollection> parseGameCollections(Stream<String> input) {
        List<GameCollection> gameCollectionList = new ArrayList<>();
        for(String line : input.toList()) {
            String[] parts = line.split(":");
            int nr = Integer.parseInt(parts[0].replace("Game ", "").trim());
            String[] gameStrings = parts[1].split(";");
            List<Game> games = new ArrayList<>();
            for(String gameString : gameStrings) {
                String[] gameStringParts = gameString.split(",");
                int green = 0, blue = 0, red = 0;
                for(String gameStringPart : gameStringParts) {
                    String[] revealedCubes = gameStringPart.trim().split(" ");
                    int num = Integer.parseInt(revealedCubes[0]);
                    String color = revealedCubes[1];
                    switch(color) {
                        case "green": green = num; break;
                        case "blue": blue = num; break;
                        case "red": red = num; break;
                    }
                }
                Game game = new Game(green, red, blue);
                games.add(game);
            }
            GameCollection collection = new GameCollection(nr, games);
            gameCollectionList.add(collection);
        }

        return gameCollectionList;
    }
}
