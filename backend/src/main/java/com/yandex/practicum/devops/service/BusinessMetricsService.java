package com.yandex.practicum.devops.service;

import com.yandex.practicum.devops.model.Order;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class BusinessMetricsService {

    private final MeterRegistry meterRegistry;
    private Counter munchOrderCounter;
    private Counter rusOrderCounter;
    private Counter nurnOrderCounter;
    private Counter creamyOrderCounter;
    private Counter milkOrderCounter;
    private Counter osobOrderCounter;

    private List<Order> orders = new ArrayList<>();

    public BusinessMetricsService(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
        initOrderCounters();
    }

    public void initOrderCounters() {
        munchOrderCounter = this.meterRegistry.counter("sausage.orders", "type", "Мюнхенская");
        rusOrderCounter = this.meterRegistry.counter("sausage.orders", "type", "Русская");
        nurnOrderCounter = this.meterRegistry.counter("sausage.orders", "type", "Нюренбергская");
        creamyOrderCounter = this.meterRegistry.counter("sausage.orders", "type", "Сливочная");
        milkOrderCounter = this.meterRegistry.counter("sausage.orders", "type", "Молочная");
        osobOrderCounter = this.meterRegistry.counter("sausage.orders", "type", "Особая");
    }

    public void orderSausage(Order order) {
        orders.add(order);
        order.getOrderProducts().forEach(x -> {
            if (x.getProduct().getId().equals(1L)) {
                creamyOrderCounter.increment();
            } else if (x.getProduct().getId().equals(2L)) {
                osobOrderCounter.increment();
            } else if (x.getProduct().getId().equals(3L)) {
                milkOrderCounter.increment();
            } else if (x.getProduct().getId().equals(4L)) {
                nurnOrderCounter.increment();
            } else if (x.getProduct().getId().equals(5L)) {
                munchOrderCounter.increment();
            } else if (x.getProduct().getId().equals(6L)) {
                rusOrderCounter.increment();
            }
        });
    }

}
