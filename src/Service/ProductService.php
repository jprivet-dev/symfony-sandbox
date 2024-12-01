<?php

namespace App\Service;

use App\Entity\Product;
use App\Repository\ProductRepository;

readonly class ProductService
{
    public function __construct(private ProductRepository $productRepository)
    {
    }

    public function create(): Product
    {
        $product = new Product();
        $product->setName('Keyboard');
        $product->setPrice(1999);
        $product->setDescription('Ergonomic and stylish!');

        $this->productRepository->save($product);

        return $product;
    }

    public function remove(Product $product): void
    {
        $this->productRepository->remove($product);
    }
}
