<?php

namespace App\DataFixtures;

use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class UserFixtures extends Fixture
{
    public const ADMIN = 'admin';
    public const ADMIN_2 = 'admin_2';
    public const USER = 'user';
    public const PASSWORD = 'password';

    public function __construct(private readonly UserPasswordHasherInterface $passwordHasher)
    {
    }

    public function load(ObjectManager $manager): void
    {
        foreach ($this->getData() as [$username, $email, $password, $roles]) {
            $user = new User();
            $user->setUsername($username);
            $user->setEmail($email);
            $user->setPassword($this->passwordHasher->hashPassword($user, $password));
            $user->setRoles($roles);

            $manager->persist($user);
            $this->addReference($username, $user);
        }

        $manager->flush();
    }

    /**
     * @return non-empty-array<array>
     */
    private function getData(): array
    {
        return [
            // $userData = [$username, $email, $password, $roles];
            [static::ADMIN, static::ADMIN.'@email.com', static::PASSWORD, [User::ROLE_ADMIN]],
            [static::ADMIN_2, static::ADMIN_2.'@email.com', static::PASSWORD, [User::ROLE_ADMIN]],
            [static::USER, static::USER.'@email.com', static::PASSWORD, [User::ROLE_USER]],
        ];
    }
}
