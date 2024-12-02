<?php

namespace App\DataFixtures;

use App\Entity\Product;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class ProductFixture extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $product = new Product();
        $product->setName('Priceless widget');
        $product->setPrice(14);
        $product->setDescription('Ok, I guess it *does* have a price');
        $manager->persist($product);

        $manager->flush();
    }
}
