<?php

namespace App\DataFixtures;

use App\Entity\Tag;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class TagFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        foreach (self::getTagData() as $name) {
            $tag = new Tag($name);

            $manager->persist($tag);
            $this->addReference('tag-'.$name, $tag);
        }

        $manager->flush();
    }

    /**
     * @return string[]
     */
    public static function getTagData(): array
    {
        return [
            'book',
            'code',
            'feature',
            'france',
            'github',
            'guide',
            'holiday',
            'images',
            'markdown',
            'math',
            'multi-author',
            'next-js',
            'ols',
            'reflection',
            'symfony',
            'tailwind',
            'writings',
        ];
    }
}
