package sk.jankovj.demo.rest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String sayHello() {
        String test_url = System.getenv("TEST_URL");

        return "Hello World!" + " " + test_url;
    }
}
