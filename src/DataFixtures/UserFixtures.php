<?php

namespace App\DataFixtures;

use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class UserFixtures extends Fixture
{
    public const JANE_ADMIN = 'jane_admin';
    public const TOM_ADMIN = 'tom_admin';
    public const JOHN_USER = 'john_user';

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
            [static::JANE_ADMIN, 'jane_admin@symfony.com', 'password', [User::ROLE_ADMIN]],
            [static::TOM_ADMIN, 'tom_admin@symfony.com', 'password', [User::ROLE_ADMIN]],
            [static::JOHN_USER, 'john_user@symfony.com', 'password', [User::ROLE_USER]],
        ];
    }
}
