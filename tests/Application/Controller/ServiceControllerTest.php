<?php

namespace App\Tests\Application\Controller;

use Symfony\Bundle\FrameworkBundle\KernelBrowser;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class ServiceControllerTest extends WebTestCase
{
    private KernelBrowser $client;

    protected function setUp(): void
    {
        $this->client = static::createClient();
    }

    public function testCreate(): void
    {
        $this->client->request('GET', '/product');
        $this->assertResponseIsSuccessful();
        $this->assertSelectorTextContains('body', 'Saved new product with id');
    }

    public function testShow(): void
    {
        $this->client->request('GET', '/product/1');
        $this->assertResponseIsSuccessful();
        $this->assertSelectorTextContains('body', 'Check out this great product: Priceless widget');
    }

    public function testRemove(): void
    {
        $this->client->request('GET', '/product/1/remove');
        $this->assertResponseIsSuccessful();
        $this->assertSelectorTextContains('body', 'Remove the product with id');
    }
}
