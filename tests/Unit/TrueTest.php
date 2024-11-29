<?php

namespace App\Tests\Unit;

use App\Entity\Product;
use PHPUnit\Framework\TestCase;

class TrueTest extends TestCase
{
    public function testSomething(): void
    {
        $product = new Product();
        $product->setName('__NAME__');
        $product->setPrice(2000);

        $this->assertSame('__NAME__', $product->getName());
        $this->assertSame(2000, $product->getPrice());
    }
}
