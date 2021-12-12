package io.github.sgbasaraner.funxchange.entity;

import org.hibernate.annotations.NaturalId;

import javax.persistence.*;
import java.util.Objects;
import java.util.Set;

@Entity
@Table(name = "interest")
public class Interest {
    @Id
    private String name;

    @ManyToMany(mappedBy = "interests")
    private Set<User> users;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Interest interest = (Interest) o;
        return name.equals(interest.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }
}
