<?php

namespace App\Tests\Functional\Application;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\HttpFoundation\Request;

class SmokeTest extends WebTestCase
{
    /**
     * @dataProvider getPublicUrl
     */
    public function testPublicPageIsSuccessful(string $url): void
    {
        $client = static::createClient();
        $client->request(Request::METHOD_GET, $url);
        $this->assertResponseIsSuccessful();
    }

    /**
     * Show routes:
     *   $ make sf p="debug:router"
     */
    public static function getPublicUrl(): \Generator
    {
        yield ['/'];
        yield ['/about'];
        yield ['/blog/'];
        yield ['/blog/lorem-ipsum-dolor-sit-amet-consectetur-adipiscing-elit'];
        yield ['/posts/'];
        yield ['/projects'];
        yield ['/tags'];
        yield ['/login'];
    }
}
