package network.froehlich.project2;

import static org.assertj.core.api.Assertions.assertThat;

import network.froehlich.project2.controller.TaskController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ApplicationTests {

    @Autowired
    private TaskController taskController;

    @Test
    void task1IsCorrect() {
        assertThat(this.taskController.task1()).isEqualTo("2683");
    }

    @Test
    void task2IsCorrect() {
        assertThat(this.taskController.task2()).isEqualTo("49710");
    }

}
