package com.yandex.practicum.devops.service;

import com.yandex.practicum.devops.model.Order;
import com.yandex.practicum.devops.repository.OrderRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    private OrderRepository orderRepository;
    private BusinessMetricsService metricsService;

    public OrderServiceImpl(OrderRepository orderRepository, BusinessMetricsService metricsService) {
        this.orderRepository = orderRepository;
        this.metricsService = metricsService;
    }

    @Override
    public Iterable<Order> getAllOrders() {
        return this.orderRepository.findAll();
    }

    @Override
    public Order create(Order order) {
        order.setDateCreated(LocalDate.now());
        metricsService.initOrderCounters();
        Order o = this.orderRepository.save(order);
        metricsService.orderSausage(o);
        return o;
    }

    @Override
    public void update(Order order) {
        this.orderRepository.save(order);
        metricsService.orderSausage(order);

    }
}
