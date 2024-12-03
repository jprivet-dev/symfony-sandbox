<?php

namespace App\Tests\Application\Controller;

use App\Repository\ProductRepository;
use Symfony\Bundle\FrameworkBundle\KernelBrowser;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\DependencyInjection\Container;

class ServiceControllerTest extends WebTestCase
{
    private KernelBrowser $client;
    private Container $container;

    protected function setUp(): void
    {
        $this->client = static::createClient();
        $this->container = static::getContainer();
    }

    public function testCreate(): void
    {
        $productRepository = $this->container->get(ProductRepository::class);
        $allBeforeRequest = $productRepository->findAll();

        $this->client->request('GET', '/product');
        $all = $productRepository->findAll();
        $end = end($all);

        $this->assertResponseIsSuccessful();
        $this->assertCount(1, $allBeforeRequest);
        $this->assertCount(2, $all);
        $this->assertSelectorTextContains('body', sprintf('Saved new product with id %s', $end->getId()));
    }

    public function testShow(): void
    {
        $productRepository = $this->container->get(ProductRepository::class);
        $allBeforeRequest = $productRepository->findAll();
        $end = end($allBeforeRequest);

        $this->client->request('GET', sprintf('/product/%s', $end->getId()));
        $all = $productRepository->findAll();

        $this->assertResponseIsSuccessful();
        $this->assertCount(1, $allBeforeRequest);
        $this->assertCount(1, $all);
        $this->assertSelectorTextContains('body', 'Check out this great product: Priceless widget');
    }

    public function testRemove(): void
    {
        $productRepository = $this->container->get(ProductRepository::class);
        $allBeforeRequest = $productRepository->findAll();
        $end = end($allBeforeRequest);

        $this->client->request('GET', sprintf('/product/%s/remove', $end->getId()));
        $all = $productRepository->findAll();

        $this->assertResponseIsSuccessful();
        $this->assertCount(1, $allBeforeRequest);
        $this->assertCount(0, $all);
    }
}
