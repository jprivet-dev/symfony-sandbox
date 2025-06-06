<?php

namespace App\DataFixtures;

use App\Entity\Tag;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\String\Slugger\SluggerInterface;

class TagFixtures extends Fixture
{
    public function __construct(private readonly SluggerInterface $slugger)
    {
    }

    public function load(ObjectManager $manager): void
    {
        foreach (self::getTagData() as $name) {
            $tag = new Tag($name);
            // $tag->setSlug($this->slugger->slug($name)->lower());

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
