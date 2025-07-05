<?php

namespace App\Tests\Functional\Application;

use App\DataFixtures\UserFixtures;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class LoginControllerTest extends WebTestCase
{
    public function testLoginFail(): void
    {
        $client = static::createClient();
        $client->request('GET', '/login');

        $client->submitForm('Login to your account', [
            '_username' => 'wrong_username',
            '_password' => 'wrong_password',
        ]);

        self::assertResponseRedirects('/login');
        $client->followRedirect();

        self::assertResponseIsSuccessful();
        self::assertSelectorTextContains('#login-alert', 'Invalid credentials.');
    }

    public function testLoginSuccess(): void
    {
        $client = static::createClient();
        $client->request('GET', '/login');

        $client->submitForm('Login to your account', [
            '_username' => UserFixtures::ADMIN,
            '_password' => UserFixtures::PASSWORD,
        ]);

        self::assertResponseRedirects('/login');
        $client->followRedirect();

        self::assertResponseIsSuccessful();
    }
}
