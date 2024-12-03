<?php

namespace App\Tests\Integration\Service;

use App\Repository\ProductRepository;
use App\Service\ProductService;
use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;

class ProductServiceTest extends KernelTestCase
{
    private ProductRepository $productRepository;
    private ProductService $productService;

    protected function setUp(): void
    {
        $container = static::getContainer();
        $this->productRepository = $container->get(ProductRepository::class);
        $this->productService = $container->get(ProductService::class);
    }

    public function testCreate(): void
    {
        $allBeforeRequest = $this->productRepository->findAll();

        $product = $this->productService->create();

        $this->assertCount(1, $allBeforeRequest);
        $this->assertCount(2, $this->productRepository->findAll());
        $this->assertSame('Keyboard', $product->getName());
    }

    public function testRemove(): void
    {
        $product = $this->productRepository->find(1);
        $allBeforeRequest = $this->productRepository->findAll();

        $this->productService->remove($product);

        $this->assertCount(1, $allBeforeRequest);
        $this->assertCount(0, $this->productRepository->findAll());
        $this->assertSame('Priceless widget', $product->getName());
    }
}
