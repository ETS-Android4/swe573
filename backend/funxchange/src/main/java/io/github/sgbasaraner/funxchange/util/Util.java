package io.github.sgbasaraner.funxchange.util;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Component;

@Component
public class Util {
    public Pageable makePageable(int offset, int limit, Sort sort) {
        if (offset < 0 || limit <= 0)
            throw new IllegalArgumentException("Invalid limit or offset");
        int currentPage = offset / limit;
        return PageRequest.of(currentPage, limit, sort);
    }
}
