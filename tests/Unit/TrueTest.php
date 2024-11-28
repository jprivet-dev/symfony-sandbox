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
        $this->assertSame('__NAME__', $product->getName());
    }
}
