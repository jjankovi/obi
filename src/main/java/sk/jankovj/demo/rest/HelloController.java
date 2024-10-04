package sk.jankovj.demo.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @Autowired
    private Environment env;

    @GetMapping("/")
    public String sayHello() {
        String environment = env.getProperty("environment");
        String test_url = env.getProperty("test.url");
        return environment + " Hello World!" + " " + test_url;
    }
}
