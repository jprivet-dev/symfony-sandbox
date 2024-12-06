<?php

namespace App\DataFixtures;

use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class UserFixtures extends Fixture
{
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
            ['jane_admin', 'jane_admin@symfony.com', 'password', [User::ROLE_ADMIN]],
            ['tom_admin', 'tom_admin@symfony.com', 'password', [User::ROLE_ADMIN]],
            ['john_user', 'john_user@symfony.com', 'password', [User::ROLE_USER]],
        ];
    }
}
