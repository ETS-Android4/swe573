package io.github.sgbasaraner.funxchange.entity;

import javax.persistence.*;

@Entity
@Table(name = "test")
public class Test {
    @Id
    @GeneratedValue
    private long id;

    @Column(nullable = false)
    private String testValue;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTestValue() {
        return testValue;
    }

    public void setTestValue(String testValue) {
        this.testValue = testValue;
    }
}
