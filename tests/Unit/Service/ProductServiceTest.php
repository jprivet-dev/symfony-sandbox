<?php

namespace App\Tests\Unit\Service;

use App\Entity\Product;
use App\Repository\ProductRepository;
use App\Service\ProductService;
use PHPUnit\Framework\TestCase;

class ProductServiceTest extends TestCase
{
    private ProductRepository $productRepository;
    private ProductService $productService;

    protected function setUp(): void
    {
        $this->productRepository = $this->createMock(ProductRepository::class);
        $this->productService = new ProductService($this->productRepository);
    }

    public function testCreate(): void
    {
        $this->productRepository
            ->expects(self::once())
            ->method('save');

        $product = $this->productService->create();
        $this->assertSame('Keyboard', $product->getName());
    }

    public function testRemove(): void
    {
        $product = new Product();

        $this->productRepository
            ->expects(self::once())
            ->method('remove')
            ->with($product);

        $this->productService->remove($product);
    }
}
