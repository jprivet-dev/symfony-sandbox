<?php

namespace App\Tests\Application\Controller;

use App\Repository\ProductRepository;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class ServiceControllerTest extends WebTestCase
{
    public function testCreate(): void
    {
        $client = static::createClient();

        $container = static::getContainer();
        $productRepository = $container->get(ProductRepository::class);

        $this->assertCount(1, $productRepository->findAll());

        $client->request('GET', '/product');
        $this->assertResponseIsSuccessful();

        $all = $productRepository->findAll();
        $this->assertCount(2, $all);

        $end = end($all);
        $this->assertSelectorTextContains('body', sprintf('Saved new product with id %s', $end->getId()));
    }

    public function testShow(): void
    {
        $client = static::createClient();

        $container = static::getContainer();
        $productRepository = $container->get(ProductRepository::class);

        $all = $productRepository->findAll();
        $this->assertCount(1, $all);

        $end = end($all);
        $client->request('GET', sprintf('/product/%s', $end->getId()));
        $this->assertResponseIsSuccessful();
        $this->assertSelectorTextContains('body', 'Check out this great product: Priceless widget');
    }

    public function testRemove(): void
    {
        $client = static::createClient();

        $container = static::getContainer();
        $productRepository = $container->get(ProductRepository::class);

        $all = $productRepository->findAll();
        $this->assertCount(1, $all);

        $end = end($all);
        $client->request('GET', sprintf('/product/%s/remove', $end->getId()));
        $this->assertResponseIsSuccessful();
        $this->assertCount(0, $productRepository->findAll());
    }
}
