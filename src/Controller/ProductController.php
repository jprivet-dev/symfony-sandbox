<?php

namespace App\Controller;

use App\Entity\Product;
use App\Service\ProductService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class ProductController extends AbstractController
{
    #[Route('/product', name: 'product_create')]
    public function create(ProductService $productService): Response
    {
        return new Response('Saved new product with id '.$productService->create()->getId());
    }

    #[Route('/product/{id}', name: 'product_show')]
    public function show(Product $product): Response
    {
        return new Response('Check out this great product: '.$product->getName());
    }

    #[Route('/product/{id}/remove', name: 'product_remove')]
    public function remove(Product $product, ProductService $productService): Response
    {
        $productService->remove($product);

        return new Response('Remove the product with id '.$product->getId());
    }
}
