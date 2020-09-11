package ch.so.agi.searchservice;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
public class MainController {
    private final Logger log = LoggerFactory.getLogger(this.getClass());

    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return new ResponseEntity<String>("searchservice", HttpStatus.OK);
    }
    
    @GetMapping("/foo")
    public ResponseEntity<String> foo() {
        return new ResponseEntity<String>("searchservice", HttpStatus.OK);
    }

}
