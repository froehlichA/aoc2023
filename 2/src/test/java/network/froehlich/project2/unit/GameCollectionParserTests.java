package network.froehlich.project2.unit;

import network.froehlich.project2.parser.GameCollectionParser;
import network.froehlich.project2.pojo.Game;
import network.froehlich.project2.pojo.GameCollection;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.Assertions;

@SpringBootTest
class GameCollectionParserTests {

    @Autowired
    GameCollectionParser parser;

    @Test
    void parsesLineCounts() {
        Stream<String> stream = Stream.of(
                "Game 1: 6 green, 3 blue; 3 red, 1 green; 4 green, 3 red, 5 blue",
                "Game 2: 2 red, 7 green; 13 green, 2 blue, 4 red; 4 green, 5 red, 1 blue; 1 blue, 9 red, 1 green"
        );
        List<GameCollection> collections = this.parser.parseGameCollections(stream);

        assertThat(collections).hasSize(2);
    }

    @Test
    void parsesNrs() {
        Stream<String> stream = Stream.of(
                "Game 1: 6 green, 3 blue; 3 red, 1 green; 4 green, 3 red, 5 blue",
                "Game 2: 2 red, 7 green; 13 green, 2 blue, 4 red; 4 green, 5 red, 1 blue; 1 blue, 9 red, 1 green"
        );
        List<GameCollection> collections = this.parser.parseGameCollections(stream);

        Assertions.assertArrayEquals(
                collections.stream().mapToInt(GameCollection::nr).toArray(),
                new int[]{1, 2}
        );
    }

    @Test
    void parsesGames() {
        Stream<String> stream = Stream.of(
                "Game 1: 6 green, 3 blue; 3 red, 1 green; 4 green, 3 red, 5 blue"
        );
        List<GameCollection> collections = this.parser.parseGameCollections(stream);

        assertThat(collections.get(0).games()).hasSize(3);
        assertThat(collections.get(0).games().get(0)).isEqualTo(new Game(6, 0, 3));
        assertThat(collections.get(0).games().get(1)).isEqualTo(new Game(1, 3, 0));
        assertThat(collections.get(0).games().get(2)).isEqualTo(new Game(4, 3, 5));
    }
}
